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

	if survey.Sample.Type != "" {
		if survey.Sample.Size <= 0 {
			return fmt.Errorf("sample Size must be greater than 0")
		}
		if survey.Sample.Location.Country == "" {
			return fmt.Errorf("sample Location Country is required")
		}
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

type SurveysResulat struct {
	List *[]domain.SurveyBadge
	Err  error
}

type SurveyUseCase interface {
	CreateSurvey(c context.Context, survey *SurveyParams) *SurveyResulat
	UpdateSurvey(c context.Context, survey *SurveyParams) *SurveyResulat
	DeleteSurvey(c context.Context, survey *SurveyParams) (bool, error)
	GetSurveyById(c context.Context, survey *SurveyParams) *SurveyResulat
	GetMySurveys(c context.Context, survey *SurveyParams) *SurveysResulat
}

type surveyUseCase struct {
	repo       repository.SurveyRepository
	collection string
}

func crudServey(repo repository.SurveyRepository, c context.Context, params *SurveyParams, action string) interface{} {
	survey := params.Data
	var err error
	if params.Data == nil {
		return &SurveyResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	var result *domain.Survey
	switch action {
	case "update":
		{
			err = ValidateSurvey(survey)
			if err != nil {
				return &SurveyResulat{
					Data: nil,
					Err:  err,
				}
			}
			result, err = repo.UpdateSurvey(c, survey)

		}
	case "add":
		{
			err = ValidateSurvey(survey)
			if err != nil {
				return &SurveyResulat{
					Data: nil,
					Err:  err,
				}
			}
			result, err = repo.CreateSurvey(c, survey)

		}
	case "getOne":
		{
			result, err = repo.GetSurveyById(c, params.Data.ID, params.Data.UserId)
		}
	case "getAll":
		{
			result, err := repo.GetMySurveys(c, params.Data.UserId)
			if err != nil {
				return &SurveysResulat{
					List: nil,
					Err:  fmt.Errorf("error in  %v survey: %v", action, err),
				}
			}
			return &SurveysResulat{
				List: result,
				Err:  nil,
			}
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

// GetMySurveys implements SurveyUseCase.
func (su *surveyUseCase) GetMySurveys(c context.Context, params *SurveyParams) *SurveysResulat {
	return crudServey(su.repo, c, params, "getAll").(*SurveysResulat)
}

// GetSurveyById implements SurveyUseCase.
func (su *surveyUseCase) GetSurveyById(c context.Context, params *SurveyParams) *SurveyResulat {
	return crudServey(su.repo, c, params, "getOne").(*SurveyResulat)
}

// DeleteSurvey implements SurveyUseCase.
func (su *surveyUseCase) DeleteSurvey(c context.Context, params *SurveyParams) (bool, error) {
	value, err := su.repo.DeleteSurvey(c, params.Data.ID, params.Data.UserId)
	if err != nil {
		return value, err
	}
	return value, err
}

// UpdateSurvey implements SurveyUseCase.
func (su *surveyUseCase) UpdateSurvey(c context.Context, params *SurveyParams) *SurveyResulat {
	return crudServey(su.repo, c, params, "update").(*SurveyResulat)
}

// CreateSurvey implements SurveyRepository.
func (su *surveyUseCase) CreateSurvey(c context.Context, params *SurveyParams) *SurveyResulat {
	return crudServey(su.repo, c, params, "add").(*SurveyResulat)
}
