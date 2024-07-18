package usecase

import (
	"back-end/internal/domain"
	"context"
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

// SignUp implements domain.AccountUsecase.
func (au *accountUsecase[T]) SignUp(c context.Context, data *domain.SignupModel) (interface{}, error) {
	return au.repo.SignUp(c, data)
}
