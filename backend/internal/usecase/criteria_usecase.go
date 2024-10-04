package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
	"fmt"
)

type CriteriaParams struct {
	Data *domain.Criteria
}

type CriteriaResulat struct {
	Data *domain.Criteria
	Err  error
}

type CriteriasResulat struct {
	Data *[]domain.Criteria
	Err  error
}

type criteriaUseCase struct {
	repo       repository.CriteriaRepository
	collection string
}

type CriteriaUseCase interface {
	CreateCriteria(c context.Context, params *CriteriaParams) *CriteriaResulat
	UpdateCriteria(c context.Context, params *CriteriaParams) *CriteriaResulat
	DeleteCriteria(c context.Context, params *CriteriaParams) (bool, error)
	GetCriterias(c context.Context, params *CriteriaParams) *CriteriaResulat
}

func NewCriteriaUseCase(repo repository.CriteriaRepository, collection string) CriteriaUseCase {
	return &criteriaUseCase{
		repo:       repo,
		collection: collection,
	}
}

func crudCriteria(repo repository.CriteriaRepository, c context.Context, params *CriteriaParams, action string) interface{} {
	criteria := params.Data
	var err error
	if params.Data == nil {
		return &CriteriasResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	var result *domain.Criteria
	switch action {
	case "update":
		{
			err = criteria.Validate()
			if err != nil {
				return &SurveyResulat{
					Data: nil,
					Err:  err,
				}
			}
			result, err = repo.UpdateCriteria(c, criteria)
		}
	case "add":
		{
			err = criteria.Validate()
			if err != nil {
				return &SurveyResulat{
					Data: nil,
					Err:  err,
				}
			}
			result, err = repo.CreateCriteria(c, criteria)
		}
	case "getAll":
		{
			result, err := repo.GetCriterias(c, params.Data.ID)
			if err != nil {
				return &CriteriasResulat{
					Data: nil,
					Err:  fmt.Errorf("error in  %v survey: %v", action, err),
				}
			}
			return &CriteriasResulat{
				Data: result,
				Err:  nil,
			}
		}
	default:
		{
			result, err = nil, nil
		}
	}
	if err != nil {
		return &CriteriaResulat{
			Data: nil,
			Err:  fmt.Errorf("error in  %v survey: %v", action, err),
		}
	}
	return &CriteriaResulat{
		Data: result,
		Err:  nil,
	}
}

// CreateCriteria implements CriteriaUseCase.
func (cu *criteriaUseCase) CreateCriteria(c context.Context, params *CriteriaParams) *CriteriaResulat {
	return crudCriteria(cu.repo, c, params, "add").(*CriteriaResulat)
}

// DeleteCriteria implements CriteriaUseCase.
func (*criteriaUseCase) DeleteCriteria(c context.Context, params *CriteriaParams) (bool, error) {
	panic("unimplemented")
}

// GetCriterias implements CriteriaUseCase.
func (*criteriaUseCase) GetCriterias(c context.Context, params *CriteriaParams) *CriteriaResulat {
	panic("unimplemented")
}

// UpdateCriteria implements CriteriaUseCase.
func (*criteriaUseCase) UpdateCriteria(c context.Context, params *CriteriaParams) *CriteriaResulat {
	panic("unimplemented")
}
