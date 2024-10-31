package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
	"fmt"
)

type CollectorParams struct {
	Data *domain.Collector
}

type CollectorResult struct {
	Data *domain.Collector
	Err  error
}

type CollectorsResult struct {
	Data []*domain.Collector
	Err  error
}

type collectorUseCase struct {
	repo       repository.CollectorRepository
	collection string
}

type CollectorUseCase interface {
	CreateCollector(c context.Context, params *CollectorParams) *CollectorResult
	DeleteCollector(c context.Context, params *CollectorParams) (bool, error)
	GetCollector(c context.Context, params *CollectorParams) *CollectorsResult
	EstimatePriceByCollector(c context.Context, collector *domain.Collector) (float64, error)
}

func NewColllectorUseCase(repo repository.CollectorRepository, collection string) CollectorUseCase {
	return &collectorUseCase{
		repo:       repo,
		collection: collection,
	}
}

func crudCollector(repo repository.CollectorRepository, c context.Context, params *CollectorParams, action string) interface{} {
	collector := params.Data
	var err error
	if params.Data == nil {
		return &CollectorResult{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	var result *domain.Collector
	switch action {
	case "add":
		{
			err = collector.Validate()
			if err != nil {
				return &CollectorResult{
					Data: nil,
					Err:  err,
				}
			}
			result, err = repo.CreateCollector(c, collector)
		}
	case "delete":
		{
			if collector.ID != "" {
				return nil
			}
			result, err := repo.DeleteCollector(c, collector.ID)
			if err != nil {
				return nil
			}
			return result
		}
	default:
		{
			result, err = nil, nil
		}
	}
	if err != nil {
		return &CollectorResult{
			Data: nil,
			Err:  fmt.Errorf("error in  %v collector: %v", action, err),
		}
	}
	return &CollectorResult{
		Data: result,
		Err:  nil,
	}
}

// CreateCriteria implements CollectorUseCase.
func (cu *collectorUseCase) CreateCollector(c context.Context, params *CollectorParams) *CollectorResult {
	return crudCollector(cu.repo, c, params, "add").(*CollectorResult)
}

// DeleteCriteria implements CollectorUseCase.
func (cu *collectorUseCase) DeleteCollector(c context.Context, params *CollectorParams) (bool, error) {
	col := params.Data.ID
	if col == "" {
		return false, fmt.Errorf("id specified for collector")
	}
	result, err := cu.repo.DeleteCollector(c, col)
	if err != nil {
		return false, err
	}
	return result, nil
}

// GetCollector implements CollectorUseCase.
func (cu *collectorUseCase) GetCollector(c context.Context, params *CollectorParams) *CollectorsResult {
	collector := params.Data
	if collector.SurveyId == "" {
		return &CollectorsResult{
			Data: nil,
			Err:  fmt.Errorf("survey id required"),
		}
	}
	result, err := cu.repo.GetCollector(c, collector.SurveyId)
	if err != nil {
		return &CollectorsResult{
			Data: nil,
			Err:  err,
		}
	}
	return &CollectorsResult{
		Data: result,
		Err:  nil,
	}
}

// EstimatePriceByCollector implements CollectorUseCase.
func (cu *collectorUseCase) EstimatePriceByCollector(c context.Context, collector *domain.Collector) (float64, error) {
	return cu.repo.EstimatePriceByCollector(c, collector), nil
}
