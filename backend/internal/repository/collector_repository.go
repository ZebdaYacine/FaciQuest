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
	GetCollector(c context.Context, collectorId *domain.Collector) (*domain.Collector, error)
}

func NewCollectorRepository(db database.Database) CollectorRepository {
	return &collectorRepository{
		database: db,
	}
}

// GetCollector implements CollectorRepository.
func (cu *collectorRepository) GetCollector(c context.Context, collectorId *domain.Collector) (*domain.Collector, error) {
	panic("unimplemented")
}

// CreateCriteria implements CollectorRepository.
func (cu *collectorRepository) CreateCollector(c context.Context, criteria *domain.Collector) (*domain.Collector, error) {

	return nil, nil
}

// DeleteCriteria implements CollectorRepository.
func (cr *collectorRepository) DeleteCollector(c context.Context, criteriaId string) (bool, error) {

	return true, nil
}
