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

type surveyRepository struct {
	database database.Database
}

type SurveyRepository interface {
	CreateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error)
	UpdateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error)
	DeleteSurvey(c context.Context, surveyId string, userId string) (bool, error)
	GetMySurveys(c context.Context, userId string) (*[]domain.Survey, error)
	GetSurveyById(c context.Context, surveyId string, userId string) (*domain.Survey, error)
}

func NewSurveyRepository(db database.Database) SurveyRepository {
	return &surveyRepository{
		database: db,
	}
}

// DeleteSurvey implements SurveyRepository.
func (s *surveyRepository) DeleteSurvey(c context.Context, surveyId string, userId string) (bool, error) {
	collection := s.database.Collection("survey")
	id, err := primitive.ObjectIDFromHex(surveyId)
	if err != nil {
		log.Fatal(err)
	}
	filter := bson.M{
		"_id":    id,
		"userId": userId,
	}
	result, err := collection.DeleteOne(c, &filter)
	if err != nil {
		log.Printf("Failed to create survey: %v", err)
		return false, err
	}
	if result.DeletedCount == 0 {
		fmt.Println("No documents matched the filter")
		return false, nil
	}
	return true, nil
}

// GetSurveyById implements SurveyRepository.
func (s *surveyRepository) GetSurveyById(c context.Context, surveyId string, userId string) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	new_survey := &domain.Survey{}
	id, err := primitive.ObjectIDFromHex(surveyId)
	if err != nil {
		log.Fatal(err)
	}
	filter := bson.M{
		"_id":    id,
		"userId": userId,
	}
	fmt.Println(filter)
	err = collection.FindOne(c, filter).Decode(new_survey)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, fmt.Errorf("survey not found")
		}
		return nil, err
	}
	return new_survey, nil
}

// GetMySurveys implements SurveyRepository.
func (s *surveyRepository) GetMySurveys(c context.Context, userId string) (*[]domain.Survey, error) {
	collection := s.database.Collection("survey")
	list_surveys := []domain.Survey{}
	filter := bson.M{
		"userId": userId,
	}
	fmt.Println(filter)
	list, err := collection.Find(c, filter)
	if err != nil {
		return nil, err
	}
	for list.Next(c) {
		new_survey := domain.Survey{}
		if err := list.Decode(new_survey); err != nil {
			log.Fatal(err)
		}
		fmt.Println(new_survey)
		list_surveys = append(list_surveys, new_survey)
	}
	return &list_surveys, nil
}

// CreateSurvey implements SurveyRepository.
func (s *surveyRepository) CreateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	resulat, err := collection.InsertOne(c, &survey)
	if err != nil {
		log.Printf("Failed to create survey: %v", err)
		return nil, err
	}
	surveyId := resulat.(string)
	survey.ID = surveyId
	return survey, nil
}

// UpdateSurvey implements SurveyRepository.
func (s *surveyRepository) UpdateSurvey(c context.Context, updatedSurvey *domain.Survey) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	id, err := primitive.ObjectIDFromHex(updatedSurvey.ID)
	if err != nil {
		log.Fatal(err)
	}
	filterUpdate := bson.D{{Key: "_id", Value: id}}
	update := bson.M{"$set": updatedSurvey}
	_, err = collection.UpdateOne(c, filterUpdate, update)
	if err != nil {
		log.Panic(err)
		return nil, err
	}
	new_survey := &domain.Survey{}
	err = collection.FindOne(c, filterUpdate).Decode(new_survey)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, fmt.Errorf("survey not found")
		}
		return nil, err
	}
	return new_survey, nil
}
