package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"
	"time"

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
	GetMySurveys(c context.Context, userId string) (*[]domain.SurveyBadge, error)
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
func (s *surveyRepository) GetMySurveys(c context.Context, userId string) (*[]domain.SurveyBadge, error) {
	collection := s.database.Collection("survey")
	list_surveys := []domain.SurveyBadge{}
	filter := bson.M{
		"userId": userId,
	}
	list, err := collection.Find(c, filter)
	if err != nil {
		return nil, err
	}
	defer list.Close(c)
	survey_badge := domain.SurveyBadge{}
	for list.Next(c) {
		new_survey := domain.Survey{}
		if err := list.Decode(&new_survey); err != nil {
			log.Fatal(err)
		}
		fmt.Println(new_survey.ID)
		survey_badge.ID = new_survey.ID
		survey_badge.Name = new_survey.Name
		survey_badge.Status = new_survey.Status
		survey_badge.Description = new_survey.Description
		survey_badge.Topics = new_survey.Topics
		survey_badge.UserId = new_survey.UserId
		survey_badge.CreatedAt = new_survey.CreatedAt
		survey_badge.UpdatedAt = new_survey.UpdatedAt
		survey_badge.Languages = new_survey.Languages
		survey_badge.CountQuestions = len(new_survey.Questions)
		list_surveys = append(list_surveys, survey_badge)
	}
	if err := list.Err(); err != nil {
		return nil, err
	}
	return &list_surveys, nil
}

// CreateSurvey implements SurveyRepository.
func (s *surveyRepository) CreateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	survey.CreatedAt = time.Now()
	// survey.UpdatedAt = time.Now()
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
	updatedSurvey.UpdatedAt = time.Now()
	filterUpdate := bson.D{{Key: "_id", Value: id}}
	update := bson.M{
		"$set": updatedSurvey,
	}
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
