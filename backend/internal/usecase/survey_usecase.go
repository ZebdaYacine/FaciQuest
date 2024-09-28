package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
	"fmt"
)

func ValidateSurvey(survey *domain.Survey) error {
	if survey.Name == "" {
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
	DeleteSurvey(c context.Context, survey *SurveyParams) (bool, error)
}

type surveyUseCase struct {
	repo       repository.SurveyRepository
	collection string
}

func crudServey(repo repository.SurveyRepository, c context.Context, params *SurveyParams, action string) interface{} {
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
			value, err := repo.DeleteSurvey(c, survey.ID, survey.UserId)
			if err != nil {
				return err
			}
			return value
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

// DeleteSurvey implements SurveyUseCase.
func (su *surveyUseCase) DeleteSurvey(c context.Context, params *SurveyParams) (bool, error) {
	value := crudServey(su.repo, c, params, "delete")
	result, ok := value.(error)
	if !ok {
		return false, result
	}
	return true, nil
}

// UpdateSurvey implements SurveyUseCase.
func (su *surveyUseCase) UpdateSurvey(c context.Context, params *SurveyParams) *SurveyResulat {
	value := crudServey(su.repo, c, params, "update")
	result, ok := value.(SurveyResulat)
	if !ok {
		return &SurveyResulat{
			Data: nil,
			Err:  fmt.Errorf("invalid result type"),
		}
	}
	return &result
}

// CreateSurvey implements SurveyRepository.
func (su *surveyUseCase) CreateSurvey(c context.Context, params *SurveyParams) *SurveyResulat {
	value := crudServey(su.repo, c, params, "add")
	result, ok := value.(SurveyResulat)
	if !ok {
		return &SurveyResulat{
			Data: nil,
			Err:  fmt.Errorf("invalid result type"),
		}
	}
	return &result
}
