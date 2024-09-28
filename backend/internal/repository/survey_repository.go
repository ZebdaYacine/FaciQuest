package repository

import (
	"back-end/core"
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"log"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type surveyRepository struct {
	database database.Database
}

type SurveyRepository interface {
	CreateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error)
	UpdateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error)
}

func NewSurveyRepository(db database.Database) SurveyRepository {
	return &surveyRepository{
		database: db,
	}
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
	// _, err = collection.UpdateOne(c, filterUpdate, update)
	// if err != nil {
	// 	log.Panic(err)
	// 	return nil, err
	// }
	// new_survey := &domain.Survey{}
	// err = collection.FindOne(c, filterUpdate).Decode(new_survey)
	// if err != nil {
	// 	if err == mongo.ErrNoDocuments {
	// 		return nil, fmt.Errorf("survey not found")
	// 	}
	// 	return nil, err
	// }
	// fmt.Println(new_survey.Languages)
	// return new_survey, nil
	return core.UpdateDoc[domain.Survey](c, collection, update, filterUpdate)

}
