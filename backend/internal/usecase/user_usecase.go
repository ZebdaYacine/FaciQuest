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

// CheckMyWallet implements domain.UserUsecase.
func (au *userUsecase) CheckMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error) {
	panic("unimplemented")
}

// InitMyWallet implements domain.UserUsecase.
func (au *userUsecase) InitMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error) {
	return au.repo.InitMyWallet(c, user)
}

// UpdateMyWallet implements domain.UserUsecase.
func (au *userUsecase) UpdateMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error) {
	panic("unimplemented")
}

// UpdateProfile implements domain.UserRepository.
func (au *userUsecase) UpdateProfile(c context.Context, data *domain.User) (*domain.User, error) {
	return au.repo.UpdateProfile(c, data)
}

// IsAlreadyExist implements domain.UserRepository.
func (au *userUsecase) IsAlreadyExist(c context.Context, data *domain.SignupModel) (bool, error) {
	return au.repo.IsAlreadyExist(c, data)
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
