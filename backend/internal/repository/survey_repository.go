package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
)

type surveyRepository struct {
	database database.Database
}

type SurveyRepository interface {
	CreateSurvey(c context.Context, survey domain.Survey) (*domain.Survey, error)
}

func NewSurveyRepository(db database.Database) SurveyRepository {
	return &surveyRepository{
		database: db,
	}
}

// CreateSurvey implements SurveyRepository.
func (s *surveyRepository) CreateSurvey(c context.Context, survey domain.Survey) (*domain.Survey, error) {
	return &domain.Survey{}, nil
}
