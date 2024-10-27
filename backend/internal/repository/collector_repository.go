package repository

import (
	"back-end/core"
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"

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
	GetCollector(c context.Context, collectorId string) (*domain.Collector, error)
	EstimatePriceByCollector(c context.Context, collector *domain.Collector) float64
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
func (cr *collectorRepository) GetCollector(c context.Context, surveyID string) (*domain.Collector, error) {
	collection := cr.database.Collection(core.COLLECTOR)
	new_collector := &domain.Collector{}
	filter := bson.M{
		"surveyId": surveyID,
	}
	fmt.Println(filter)
	err := collection.FindOne(c, filter).Decode(new_collector)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, fmt.Errorf("collector not found")
		}
		return nil, err
	}
	log.Println(new_collector)
	return new_collector, nil
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
	return 2.25 * float64(collector.TargetAudience.Population)
}
