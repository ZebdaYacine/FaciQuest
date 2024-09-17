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

	// Insert the survey into the collection
	_, err := collection.InsertOne(c, survey)
	if err != nil {
		log.Printf("Failed to create survey: %v", err)
		return nil, err
	}
	log.Printf("Created survey with ID %v", survey.ID)
	return survey, nil
}

// UpdateSurvey implements SurveyRepository.
func (s *surveyRepository) UpdateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error) {
	return &domain.Survey{}, nil
}
