package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
	"fmt"
)

func ValidateSurvey(survey *domain.Survey) error {
	if survey.Title == "" {
		return fmt.Errorf("title is required")
	}
	if survey.Language == "" {
		return fmt.Errorf("language is required")
	}
	if survey.LikertScale == "" {
		return fmt.Errorf("likertScale is required")
	}
	if len(survey.Questions) == 0 {
		return fmt.Errorf("at least one question is required")
	}
	if survey.Sample.Type == "" {
		return fmt.Errorf("sample Type is required")
	}
	if survey.Sample.Size <= 0 {
		return fmt.Errorf("sample Size must be greater than 0")
	}
	if survey.Sample.Location.Country == "" {
		return fmt.Errorf("sample Location Country is required")
	}
	return nil
}

type SurveyParams struct {
	Data *domain.Survey
}
type ServeyResulat struct {
	Data any
	Err  error
}

var (
	surveyParams  = &SurveyParams{}
	serveyResulat = &ServeyResulat{}
)

type SurveyUseCase interface {
	CreateSurvey(c context.Context, survey *SurveyParams) *ServeyResulat
}

type surveyUseCase struct {
	repo       repository.SurveyRepository
	collection string
}

func NewSurveyUseCase(repo repository.SurveyRepository, collection string) SurveyUseCase {
	return &surveyUseCase{
		repo:       repo,
		collection: collection,
	}
}

// CreateSurvey implements SurveyRepository.
func (su *surveyUseCase) CreateSurvey(c context.Context, params *SurveyParams) *ServeyResulat {
	if params.Data == nil {
		return &ServeyResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	survey := params.Data
	err := ValidateSurvey(survey)
	if err != nil {
		return &ServeyResulat{
			Data: nil,
			Err:  err,
		}
	}
	result, err := su.repo.CreateSurvey(c, *survey)
	if err != nil {
		return &ServeyResulat{
			Data: nil,
			Err:  fmt.Errorf("error creating survey: %v", err),
		}
	}
	return &ServeyResulat{
		Data: result,
		Err:  nil,
	}
}
