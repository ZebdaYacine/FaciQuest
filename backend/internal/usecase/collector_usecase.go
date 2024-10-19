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

type CollectorResulat struct {
	Data *domain.Collector
	Err  error
}

type collectorUseCase struct {
	repo       repository.CollectorRepository
	collection string
}

type CollectorUseCase interface {
	CreateCollector(c context.Context, params *CollectorParams) *CollectorResulat
	DeleteCollector(c context.Context, params *CollectorParams) (bool, error)
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
		return &CriteriasResulat{
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
				return &CollectorResulat{
					Data: nil,
					Err:  err,
				}
			}
			result, err = repo.CreateCollector(c, collector)
		}
	case "delete":
		{
			result, err := repo.DeleteCollector(c, collector.ID)
			if err != nil {
				return &CollectorResulat{
					Data: nil,
					Err:  fmt.Errorf("error in  %v survey: %v", action, err),
				}
			}
			return result
		}
	default:
		{
			result, err = nil, nil
		}
	}
	if err != nil {
		return &CollectorResulat{
			Data: nil,
			Err:  fmt.Errorf("error in  %v survey: %v", action, err),
		}
	}
	return &CollectorResulat{
		Data: result,
		Err:  nil,
	}
}

// CreateCriteria implements CollectorUseCase.
func (*collectorUseCase) CreateCollector(c context.Context, params *CollectorParams) *CollectorResulat {
	panic("unimplemented")
}

// DeleteCriteria implements CollectorUseCase.
func (*collectorUseCase) DeleteCollector(c context.Context, params *CollectorParams) (bool, error) {
	panic("unimplemented")
}
