package usecase

import (
	"back-end/internal/domain"
	"context"
)

type userUsecase struct {
	repo       domain.UserRepository
	collection string
}

func NewUserUsecase(repo domain.UserRepository, collection string) domain.UserUsecase {
	return &userUsecase{
		repo:       repo,
		collection: collection,
	}
}

// RsetPassword implements domain.UserUsecase.
func (au *userUsecase) RsetPassword(c context.Context, data *domain.RestPasswordModel) (*domain.User, error) {
	return au.repo.RsetPassword(c, data)
}

// SignUp implements domain.AccountUsecase.
func (au *userUsecase) SignUp(c context.Context, data *domain.SignupModel) (*domain.User, error) {
	return au.repo.SignUp(c, data)
}

// Login implements domain.AccountUsecase.
func (au *userUsecase) Login(c context.Context, data *domain.LoginModel) (*domain.User, error) {
	return au.repo.Login(c, data)
}

// GetRole implements domain.AccountUsecase.
// func (au *userUsecase) GetRole(c context.Context, data string) (string, error) {
// 	return au.repo.GetRole(c, data)
// }
