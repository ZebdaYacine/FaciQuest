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
	GetAllSurveys(c context.Context) (*[]domain.SurveyBadge, error)
	GetSurveysByStatus(c context.Context, status string) (*[]domain.SurveyBadge, error)
	GetAdminSurveys(c context.Context, status string, limit *int, offset *int, startAt *time.Time, endAt *time.Time) (*[]domain.SurveyBadge, error)
	UpdateSurveyStatus(c context.Context, surveyId string, status string) (bool, error)
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
		"_id":                id,
		"surveybadge.userId": userId,
	}
	result, err := collection.DeleteOne(c, &filter)
	if err != nil {
		log.Printf("Failed to delete survey: %v", err)
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
		"_id": id,
		//"surveybadge.userId": userId,
	}
	err = collection.FindOne(c, filter).Decode(new_survey)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, fmt.Errorf("survey not found")
		}
		return nil, err
	}
	fmt.Println(new_survey)
	return new_survey, nil
}

// GetAllSurveys implements SurveyRepository.
func (s *surveyRepository) GetAllSurveys(c context.Context) (*[]domain.SurveyBadge, error) {
	collection := s.database.Collection("survey")
	filter := bson.M{}
	list, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load surveys: %v", err)
		return nil, err
	}
	list_surveys := []domain.SurveyBadge{}
	for list.Next(c) {
		new_survey := domain.Survey{}
		if err := list.Decode(&new_survey); err != nil {
			log.Fatal(err)
		}
		list_surveys = append(list_surveys, new_survey.SurveyBadge)
	}
	return &list_surveys, nil
}

// GetMySurveys implements SurveyRepository.
func (s *surveyRepository) GetMySurveys(c context.Context, userId string) (*[]domain.SurveyBadge, error) {
	collection := s.database.Collection("survey")
	filter := bson.M{
		"surveybadge.userId": userId,
	}
	list, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load surveys: %v", err)
		return nil, err
	}
	list_surveys := []domain.SurveyBadge{}
	for list.Next(c) {
		new_survey := domain.Survey{}
		if err := list.Decode(&new_survey); err != nil {
			log.Fatal(err)
		}
		list_surveys = append(list_surveys, new_survey.SurveyBadge)
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
	survey, err = s.UpdateSurvey(c, survey)
	if err != nil {
		log.Printf("Failed to update survey: %v", err)
		return nil, err
	}
	log.Println(survey)
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

// GetSurveysByStatus implements SurveyRepository.
func (s *surveyRepository) GetSurveysByStatus(c context.Context, status string) (*[]domain.SurveyBadge, error) {
	collection := s.database.Collection("survey")
	filter := bson.M{}
	if status != "" {
		filter = bson.M{
			"surveybadge.status": status,
		}
	}
	list, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load surveys by status: %v", err)
		return nil, err
	}
	list_surveys := []domain.SurveyBadge{}
	for list.Next(c) {
		new_survey := domain.Survey{}
		if err := list.Decode(&new_survey); err != nil {
			log.Fatal(err)
		}
		list_surveys = append(list_surveys, new_survey.SurveyBadge)
	}
	return &list_surveys, nil
}

func (s *surveyRepository) GetAdminSurveys(c context.Context, status string, limit *int, offset *int, startAt *time.Time, endAt *time.Time) (*[]domain.SurveyBadge, error) {
	collection := s.database.Collection("survey")
	filter := bson.M{}
	and := []bson.M{}
	if status != "" {
		and = append(and, bson.M{"surveybadge.status": status})
	}
	if startAt != nil {
		and = append(and, bson.M{"surveybadge.createdAt": bson.M{"$gte": *startAt}})
	}
	if endAt != nil {
		and = append(and, bson.M{"surveybadge.createdAt": bson.M{"$lte": *endAt}})
	}
	if len(and) > 0 {
		filter = bson.M{"$and": and}
	}

	cursor, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load admin surveys: %v", err)
		return nil, err
	}
	var all []domain.SurveyBadge
	for cursor.Next(c) {
		var doc domain.Survey
		if err := cursor.Decode(&doc); err != nil {
			return nil, err
		}
		all = append(all, doc.SurveyBadge)
	}
	_ = cursor.Close(c)

	l := 50
	o := 0
	if limit != nil && *limit > 0 {
		l = *limit
	}
	if offset != nil && *offset >= 0 {
		o = *offset
	}
	if o > len(all) {
		return &[]domain.SurveyBadge{}, nil
	}
	end := o + l
	if end > len(all) {
		end = len(all)
	}
	paged := all[o:end]
	return &paged, nil
}

func (s *surveyRepository) UpdateSurveyStatus(c context.Context, surveyId string, status string) (bool, error) {
	collection := s.database.Collection("survey")
	id, err := primitive.ObjectIDFromHex(surveyId)
	if err != nil {
		return false, fmt.Errorf("invalid surveyId")
	}
	update := bson.M{
		"$set": bson.M{
			"surveybadge.status":    status,
			"surveybadge.updatedAt": time.Now(),
		},
	}
	res, err := collection.UpdateOne(c, bson.M{"_id": id}, update)
	if err != nil {
		return false, err
	}
	return res.ModifiedCount > 0, nil
}
