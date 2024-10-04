package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type criteriaRepository struct {
	database database.Database
}

type CriteriaRepository interface {
	CreateCriteria(c context.Context, criteria *domain.Criteria) (*domain.Criteria, error)
	UpdateCriteria(c context.Context, criteria *domain.Criteria) (*domain.Criteria, error)
	DeleteCriteria(c context.Context, criteriaId string) (bool, error)
	GetCriterias(c context.Context, criteria string) (*[]domain.Criteria, error)
}

func NewCriteriaRepository(db database.Database) CriteriaRepository {
	return &criteriaRepository{
		database: db,
	}
}

// CreateCriteria implements CriteriaRepository.
func (cu *criteriaRepository) CreateCriteria(c context.Context, criteria *domain.Criteria) (*domain.Criteria, error) {
	collection := cu.database.Collection("criteria")
	resulat, err := collection.InsertOne(c, &criteria)
	if err != nil {
		log.Printf("Failed to create criteria: %v", err)
		return nil, err
	}
	criteriaId := resulat.(string)
	criteria.ID = criteriaId
	criteria, err = cu.UpdateCriteria(c, criteria)
	if err != nil {
		log.Printf("Failed to update criteria: %v", err)
		return nil, err
	}
	return criteria, nil
}

// DeleteCriteria implements CriteriaRepository.
func (cr *criteriaRepository) DeleteCriteria(c context.Context, criteriaId string) (bool, error) {
	collection := cr.database.Collection("criteria")
	id, err := primitive.ObjectIDFromHex(criteriaId)
	if err != nil {
		log.Fatal(err)
	}
	delete := bson.M{
		"_id": id,
	}
	result, err := collection.DeleteOne(c, delete)
	if err != nil {
		log.Printf("Failed to delete criteria: %v", err)
		return false, err
	}
	if result.DeletedCount == 0 {
		fmt.Println("No documents matched the filter")
		return false, nil
	}
	return true, nil
}

// GetCriterias implements CriteriaRepository.
func (cr *criteriaRepository) GetCriterias(c context.Context, criteriaId string) (*[]domain.Criteria, error) {
	collection := cr.database.Collection("criteria")
	id, err := primitive.ObjectIDFromHex(criteriaId)
	if err != nil {
		log.Fatal(err)
	}
	filter := bson.M{
		"_id": id,
	}
	list, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load criteria: %v", err)
		return nil, err
	}
	list_criterias := []domain.Criteria{}
	for list.Next(c) {
		new_criteria := domain.Criteria{}
		if err := list.Decode(&new_criteria); err != nil {
			log.Fatal(err)
		}
		list_criterias = append(list_criterias, new_criteria)
	}
	return &list_criterias, nil
}

// UpdateCriteria implements CriteriaRepository.
func (cr *criteriaRepository) UpdateCriteria(c context.Context, criteria *domain.Criteria) (*domain.Criteria, error) {
	collection := cr.database.Collection("criteria")
	id, err := primitive.ObjectIDFromHex(criteria.ID)
	if err != nil {
		log.Fatal(err)
	}
	filterUpdate := bson.D{{Key: "_id", Value: id}}
	update := bson.M{
		"$set": criteria,
	}
	_, err = collection.UpdateOne(c, filterUpdate, update)
	if err != nil {
		log.Panic(err)
		return nil, err
	}
	new_criteria := &domain.Criteria{}
	err = collection.FindOne(c, filterUpdate).Decode(new_criteria)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, fmt.Errorf("survey not found")
		}
		return nil, err
	}
	return new_criteria, nil
}
