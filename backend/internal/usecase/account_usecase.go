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
func (au *accountUsecase[T]) SignUp(c context.Context, data *domain.SignupModel) (string, error) {
	return au.repo.SignUp(c, data)
}

// Login implements domain.AccountUsecase.
func (au *accountUsecase[T]) Login(c context.Context, data *domain.LoginModel) (string, error) {
	return au.repo.Login(c, data)
}

// GetRole implements domain.AccountUsecase.
func (au *accountUsecase[T]) GetRole(c context.Context, data string) (string, error) {
	return au.repo.GetRole(c, data)
}
