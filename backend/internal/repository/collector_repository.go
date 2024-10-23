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
	GetCollector(c context.Context, collectorId string) (*domain.Collector, error)
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
	id, err := primitive.ObjectIDFromHex(surveyID)
	new_collector := &domain.Collector{}
	if err != nil {
		log.Fatal(err)
	}
	filter := bson.M{
		"_id": id,
	}
	err = collection.FindOne(c, filter).Decode(new_collector)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, fmt.Errorf("collector not found")
		}
		return nil, err
	}
	fmt.Println(new_collector)
	return new_collector, nil
}
