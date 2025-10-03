package repository

import (
	"back-end/core"
	"back-end/internal/domain"
	"back-end/pkg/database"
	util "back-end/util/tools"
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type collectorRepository struct {
	database database.Database
}

type CollectorRepository interface {
	CreateCollector(c context.Context, collector *domain.Collector) (*domain.Collector, error)
	DeleteCollector(c context.Context, collectorId string) (bool, error)
	UpdateCollector(c context.Context, collector *domain.Collector) (*domain.Collector, error)
	GetCollector(c context.Context, surveyId string, userId string) ([]*domain.Collector, error)
	EstimatePriceByCollector(c context.Context, collector *domain.Collector) float64
	ConfirmPayment(c context.Context, ConfirmPayment *domain.ConfirmPayment) bool
}

func NewCollectorRepository(db database.Database) CollectorRepository {
	return &collectorRepository{
		database: db,
	}
}

// CreateCriteria implements CollectorRepository.
func (cu *collectorRepository) CreateCollector(c context.Context, collector *domain.Collector) (*domain.Collector, error) {
	collection := cu.database.Collection(core.COLLECTOR)
	result, err := collection.InsertOne(c, &collector)
	if err != nil {
		log.Printf("Failed to create collector: %v", err)
		return nil, err
	}
	collectorId := result.(string)
	collector.ID = collectorId
	collector, err = cu.UpdateCollector(c, collector)
	if err != nil {
		log.Printf("Failed to update collector: %v", err)
		return nil, err
	}
	log.Println(collector)
	return collector, nil
}

// DeleteCriteria implements CollectorRepository.
func (cr *collectorRepository) DeleteCollector(c context.Context, collectorId string) (bool, error) {
	collection := cr.database.Collection(core.COLLECTOR)
	id, err := primitive.ObjectIDFromHex(collectorId)
	if err != nil {
		log.Fatal(err)
	}
	filter := bson.M{
		"_id": id,
	}
	result, err := collection.DeleteOne(c, &filter)
	if err != nil {
		log.Printf("Failed to delete collector: %v", err)
		return false, err
	}
	if result.DeletedCount == 0 {
		fmt.Println("No documents matched the filter")
		return false, nil
	}
	return true, nil
}

// GetCollector implements CollectorRepository.
// TODO: get list of collectors
func (cr *collectorRepository) GetCollector(c context.Context, surveyID string, userId string) ([]*domain.Collector, error) {
	collection := cr.database.Collection(core.COLLECTOR)
	filter := bson.M{
		"surveyId": surveyID,
	}
	sr := NewSurveyRepository(cr.database)
	survey, err := sr.GetSurveyById(c, surveyID, userId)
	if survey == nil || err != nil {
		log.Printf("Failed to load survey: %v", err)
		return nil, err
	}

	list, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load collectors: %v", err)
		return nil, err
	}

	list_collectors := []*domain.Collector{}

	for list.Next(c) {
		new_collector := &domain.Collector{}
		if err := list.Decode(new_collector); err != nil {
			log.Fatal(err)
		}
		list_collectors = append(list_collectors, new_collector)
	}
	log.Println(list_collectors)
	return list_collectors, nil
}

// UpdateCriteria implements CollectorRepository.
func (cr *collectorRepository) UpdateCollector(c context.Context, col *domain.Collector) (*domain.Collector, error) {
	collection := cr.database.Collection(core.COLLECTOR)
	id, err := primitive.ObjectIDFromHex(col.ID)
	if err != nil {
		log.Fatal(err)
	}
	filterUpdate := bson.D{{Key: "_id", Value: id}}
	update := bson.M{
		"$set": col,
	}
	_, err = collection.UpdateOne(c, filterUpdate, update)
	if err != nil {
		log.Panic(err)
		return nil, err
	}
	new_collector := &domain.Collector{}
	err = collection.FindOne(c, filterUpdate).Decode(new_collector)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, fmt.Errorf("collector not found")
		}
		return nil, err
	}

	return new_collector, nil
}

// EstimatePriceByCollector implements CollectorRepository.
func (cu *collectorRepository) EstimatePriceByCollector(c context.Context, collector *domain.Collector) float64 {
	surveyRepository := NewSurveyRepository(cu.database)
	survey, err := surveyRepository.GetSurveyById(c, collector.SurveyId, "")
	if err != nil || survey == nil {
		log.Printf("Failed to load survey: %v", err)
	}
	return (APP_COMMISSION + USER_COMMISSION) * float64(collector.TargetAudience.Population*survey.CountQuestions)
}

// ConfirmPayment implements CollectorRepository.
func (cu *collectorRepository) ConfirmPayment(c context.Context, ConfirmPayment *domain.ConfirmPayment) bool {
	log.Println("LAUNCHE CONFIRM PAYMENT REPOSITORY")
	log.Println(ConfirmPayment)
	dir := filepath.Join("/var/www/ftp", ConfirmPayment.CollectorId)
	if err := os.MkdirAll(dir, 0755); err != nil {
		fmt.Println("Error creating directory:", err)
	}
	log.Println("Directory ensured:", dir)
	fileDir := filepath.Join(dir, ConfirmPayment.FileName)
	filename, err := util.SaveBase64ToFile(ConfirmPayment.ProofOfPayment, fileDir)
	if err != nil {
		log.Fatalf("Failed to save image: %v", err)
	}
	ConfirmPayment.FileName = *filename
	_, err = cu.database.Collection(core.PROOF).InsertOne(c, bson.M{
		"collectorId": ConfirmPayment.CollectorId,
		"fileName":    ConfirmPayment.FileName,
		"createdAt":   time.Now(),
	})
	if err != nil {
		log.Printf("failed to insert payment in DB: %v", err)
		return false
	}
	return true
}
