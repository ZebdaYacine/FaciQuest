package usecase

import (
	"back-end/internal/domain"
	"context"
	"log"
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

// Login implements domain.AccountUsecase.
func (au *accountUsecase[T]) Login(c context.Context, data domain.LoginModel) (int64, error) {
	log.Println("Login  UseCase launched successfully")
	return au.repo.Login(c, data)
}

// GetRole implements domain.AccountUsecase.
func (au *accountUsecase[T]) GetRole(c context.Context, id int64) (int64, error) {
	log.Println("GetRole  UseCase launched successfully")
	return au.repo.GetRole(c, id)
}
