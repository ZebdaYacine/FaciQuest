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
	if len(survey.Languages) == 0 {
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
type SurveyResulat struct {
	Data *domain.Survey
	Err  error
}

type SurveyUseCase interface {
	CreateSurvey(c context.Context, survey *SurveyParams) *SurveyResulat
	UpdateSurvey(c context.Context, survey *SurveyParams) *SurveyResulat
}

type surveyUseCase struct {
	repo       repository.SurveyRepository
	collection string
}

func crudServey(repo repository.SurveyRepository, c context.Context, params *SurveyParams, action string) *SurveyResulat {
	if params.Data == nil {
		return &SurveyResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	survey := params.Data
	err := ValidateSurvey(survey)
	if err != nil {
		return &SurveyResulat{
			Data: nil,
			Err:  err,
		}
	}
	var result *domain.Survey
	switch action {
	case "delete":
		{
			result, err = repo.UpdateSurvey(c, survey)

		}
	case "update":
		{
			result, err = repo.UpdateSurvey(c, survey)

		}
	case "add":
		{
			result, err = repo.CreateSurvey(c, survey)

		}
	default:
		{
			result, err = nil, nil
		}
	}
	if err != nil {
		return &SurveyResulat{
			Data: nil,
			Err:  fmt.Errorf("error in  %v survey: %v", action, err),
		}
	}
	return &SurveyResulat{
		Data: result,
		Err:  nil,
	}
}
func NewSurveyUseCase(repo repository.SurveyRepository, collection string) SurveyUseCase {
	return &surveyUseCase{
		repo:       repo,
		collection: collection,
	}
}

// UpdateSurvey implements SurveyUseCase.
func (su *surveyUseCase) UpdateSurvey(c context.Context, params *SurveyParams) *SurveyResulat {
	return crudServey(su.repo, c, params, "update")
}

// CreateSurvey implements SurveyRepository.
func (su *surveyUseCase) CreateSurvey(c context.Context, params *SurveyParams) *SurveyResulat {
	return crudServey(su.repo, c, params, "add")
}
