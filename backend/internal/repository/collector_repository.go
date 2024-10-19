package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
)

type collectorRepository struct {
	database database.Database
}

type CollectorRepository interface {
	CreateCollector(c context.Context, collector *domain.Collector) (*domain.Collector, error)
	DeleteCollector(c context.Context, collectorId string) (bool, error)
}

func NewCollectorRepository(db database.Database) CollectorRepository {
	return &collectorRepository{
		database: db,
	}
}

// CreateCriteria implements CriteriaRepository.
func (cu *collectorRepository) CreateCollector(c context.Context, criteria *domain.Collector) (*domain.Collector, error) {

	return nil, nil
}

// DeleteCriteria implements CriteriaRepository.
func (cr *collectorRepository) DeleteCollector(c context.Context, criteriaId string) (bool, error) {

	return true, nil
}
