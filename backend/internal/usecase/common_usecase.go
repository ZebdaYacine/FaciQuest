package usecase

import (
	"back-end/internal/domain"
	"context"
	"log"
)

type commonUsecase[T domain.Person] struct {
	repo       domain.CommonRepository[T]
	collection string
}

func NewCommonUsecase[T domain.Person](repo domain.CommonRepository[T], collection string) domain.CommonUsecase[T] {
	return &commonUsecase[T]{
		repo:       repo,
		collection: collection,
	}
}

func (uu *commonUsecase[T]) CreateInsured(c context.Context, insured domain.Insured) error {
	log.Println("Create User UseCase launched successfully")
	return uu.repo.CreateInsured(c, insured)
}

func (uu *commonUsecase[T]) UpdateInsured(c context.Context, insured domain.Insured) error {
	log.Println("UPDATE User UseCase launched successfully")
	return uu.repo.UpdateInsured(c, insured)
}
