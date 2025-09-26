package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
	"fmt"
	"log"
	"time"
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

type AdminSurveyListParams struct {
	Status  string
	Limit   *int
	Offset  *int
	StartAt *time.Time
	EndAt   *time.Time
}

type AdminSurveysResult struct {
	List *[]domain.SurveyBadge
	Err  error
}

type SurveyUseCase interface {
	CreateSurvey(c context.Context, survey *SurveyParams) *SurveyResulat
	UpdateSurvey(c context.Context, survey *SurveyParams) *SurveyResulat
	DeleteSurvey(c context.Context, survey *SurveyParams) (bool, error)
	GetSurveyById(c context.Context, survey *SurveyParams) *SurveyResulat
	GetMySurveys(c context.Context, survey *SurveyParams) *SurveysResulat
	GetAllSurveys(c context.Context, userid string) *SurveysResulat
	GetSurveysByStatus(c context.Context, status string) *SurveysResulat
	GetAdminSurveys(c context.Context, params AdminSurveyListParams) *AdminSurveysResult
	UpdateSurveyStatus(c context.Context, surveyID string, status string) *struct {
		Value bool
		Err   error
	}
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
			log.Println(survey)
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
	case "getMySurveys":
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
	// case "getAll":
	// 	{
	// 		result, err := repo.GetAllSurveys(c)
	// 		if err != nil {
	// 			return &SurveysResulat{
	// 				List: nil,
	// 				Err:  fmt.Errorf("error in  %v survey: %v", action, err),
	// 			}
	// 		}
	// 		return &SurveysResulat{
	// 			List: result,
	// 			Err:  nil,
	// 		}
	// 	}
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

// GetAllSurveys implements SurveyUseCase.
func (su *surveyUseCase) GetAllSurveys(c context.Context, userid string) *SurveysResulat {
	//return crudServey(su.repo, c, nil, "getAll").(*SurveysResulat)
	result, err := su.repo.GetAllSurveys(c, userid)
	if err != nil {
		return &SurveysResulat{
			List: nil,
			Err:  fmt.Errorf("error in  %v survey: %v", "get all", err),
		}
	}
	return &SurveysResulat{
		List: result,
		Err:  nil,
	}
}

// GetSurveysByStatus implements SurveyUseCase.
func (su *surveyUseCase) GetSurveysByStatus(c context.Context, status string) *SurveysResulat {

	allowed := map[string]bool{"published": true, "pending": true, "rejected": true, "": true}
	if !allowed[status] {
		return &SurveysResulat{
			List: nil,
			Err:  fmt.Errorf("invalid status"),
		}
	}

	result, err := su.repo.GetSurveysByStatus(c, status)
	if err != nil {
		return &SurveysResulat{
			List: nil,
			Err:  fmt.Errorf("error getting surveys by status: %v", err),
		}
	}
	return &SurveysResulat{List: result, Err: nil}
}

// GetAdminSurveys implements admin listing with filters
func (su *surveyUseCase) GetAdminSurveys(c context.Context, params AdminSurveyListParams) *AdminSurveysResult {
	if params.Status != "" {
		allowed := map[string]bool{"draft": true, "active": true, "closed": true}
		if !allowed[params.Status] {
			return &AdminSurveysResult{List: nil, Err: fmt.Errorf("invalid status")}
		}
	}
	result, err := su.repo.GetAdminSurveys(c, params.Status, params.Limit, params.Offset, params.StartAt, params.EndAt)
	if err != nil {
		return &AdminSurveysResult{List: nil, Err: fmt.Errorf("error getting admin surveys: %v", err)}
	}
	return &AdminSurveysResult{List: result, Err: nil}
}

// GetMySurveys implements SurveyUseCase.
func (su *surveyUseCase) GetMySurveys(c context.Context, params *SurveyParams) *SurveysResulat {
	return crudServey(su.repo, c, params, "getMySurveys").(*SurveysResulat)
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

// UpdateSurveyStatus updates the status of a survey (admin)
func (su *surveyUseCase) UpdateSurveyStatus(c context.Context, surveyID string, status string) *struct {
	Value bool
	Err   error
} {
	if surveyID == "" {
		return &struct {
			Value bool
			Err   error
		}{Value: false, Err: fmt.Errorf("surveyId is required")}
	}
	allowed := map[string]bool{"draft": true, "active": true, "closed": true}
	if !allowed[status] {
		return &struct {
			Value bool
			Err   error
		}{Value: false, Err: fmt.Errorf("invalid status")}
	}
	ok, err := su.repo.UpdateSurveyStatus(c, surveyID, status)
	return &struct {
		Value bool
		Err   error
	}{Value: ok, Err: err}
}
