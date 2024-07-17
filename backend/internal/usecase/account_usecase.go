package usecase

import (
	"back-end/internal/domain"
)

type accountUsecase[T domain.Auth] struct {
	repo       domain.AccountRepository[T]
	collection string
}

func NewAccountUsecase[T domain.Auth](repo domain.AccountRepository[T], collection string) domain.AccountUsecase[T] {
	return &accountUsecase[T]{
		repo:       repo,
		collection: collection,
	}
}
