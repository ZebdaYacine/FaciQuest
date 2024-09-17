package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"log"
)

type surveyRepository struct {
	database database.Database
}

type SurveyRepository interface {
	CreateSurvey(c context.Context, survey domain.Survey) (*domain.Survey, error)
	UpdateSurvey(c context.Context, survey domain.Survey) (*domain.Survey, error)
}

func NewSurveyRepository(db database.Database) SurveyRepository {
	return &surveyRepository{
		database: db,
	}
}

// CreateSurvey implements SurveyRepository.
func (s *surveyRepository) CreateSurvey(c context.Context, survey domain.Survey) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	surveyId, err1 := collection.InsertOne(c, survey)
	if err1 != nil {
		log.Printf("Failed to create survey: %v", err1)
		return nil, err1
	}
	log.Printf("Create survey with id %v", surveyId.(string))
	survey.ID = surveyId.(string)
	return &domain.Survey{}, nil
}

// UpdateSurvey implements SurveyRepository.
func (s *surveyRepository) UpdateSurvey(c context.Context, survey domain.Survey) (*domain.Survey, error) {
	return &domain.Survey{}, nil
}
