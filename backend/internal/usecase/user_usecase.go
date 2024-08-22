package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
	"fmt"
	"log"
)

type UserParams struct {
	Data any
}

type UserResulat struct {
	Data *domain.User
	Err  error
}

var (
	userResulat = &UserResulat{}
)

type UserUsecase interface {
	//AUTH FUNCTIONS
	Login(c context.Context, data *UserParams) *UserResulat
	// Logout(c context.Context) error
	SignUp(c context.Context, data *UserParams) *UserResulat
	IsAlreadyExist(c context.Context, data *domain.SignupModel) (bool, error)
	//SETTING PROFILE FUNCTIONS
	GetUserByEmail(c context.Context, email string) (*domain.User, error)
	GetUserById(c context.Context, id string) (*domain.User, error)
	SetNewPassword(c context.Context, data *domain.User) (*domain.User, error)
	UpdateProfile(c context.Context, data *UserParams) *UserResulat
	//SETTING WALLET
}

type userUsecase struct {
	repo       repository.UserRepository
	collection string
}

func NewUserUsecase(repo repository.UserRepository, collection string) UserUsecase {
	return &userUsecase{
		repo:       repo,
		collection: collection,
	}
}

// UpdateProfile implements domain.UserRepository.
func (au *userUsecase) UpdateProfile(c context.Context, query *UserParams) *UserResulat {
	log.Println("LAUNCHE UPDATE PROFILE USE CASE")
	if query.Data == nil {
		userResulat.Err = fmt.Errorf("data is required")
		return userResulat
	}
	data := query.Data.(domain.User)
	log.Print(data)
	user, err := au.repo.UpdateProfile(c, &data)
	if err != nil {
		userResulat.Err = err
	}
	userResulat.Data = user
	return userResulat

}

// IsAlreadyExist implements domain.UserRepository.
func (au *userUsecase) IsAlreadyExist(c context.Context, data *domain.SignupModel) (bool, error) {
	return au.repo.IsAlreadyExist(c, data)
}

// SetNewPassword implements domain.UserUsecase.
func (au *userUsecase) SetNewPassword(c context.Context, data *domain.User) (*domain.User, error) {
	return au.repo.SetNewPassword(c, data)
}

// SignUp implements domain.AccountUsecase.
func (au *userUsecase) SignUp(c context.Context, query *UserParams) *UserResulat {
	if query.Data == nil {
		userResulat.Err = fmt.Errorf("data is required")
		return userResulat
	}
	signupModel := query.Data.(domain.SignupModel)
	user, err := au.repo.SignUp(c, &signupModel)
	if err != nil {
		userResulat.Err = err
	}
	userResulat.Data = user
	return userResulat
}

// Login implements domain.AccountUsecase.
func (au *userUsecase) Login(c context.Context, query *UserParams) *UserResulat {
	log.Println("LAUNCHE LOGIN USE CASE")
	if query.Data == nil {
		userResulat.Err = fmt.Errorf("data is required")
		return userResulat
	}
	loginModel := query.Data.(domain.LoginModel)
	log.Println(loginModel)
	user, err := au.repo.Login(c, &loginModel)
	if err != nil {
		userResulat.Err = err
	}
	userResulat.Data = user
	return userResulat
}

// GetUserByEmail implements domain.UserUsecase.
func (au *userUsecase) GetUserByEmail(c context.Context, data string) (*domain.User, error) {
	return au.repo.GetUserByEmail(c, data)
}

// GetUserById implements UserUsecase.
func (au *userUsecase) GetUserById(c context.Context, id string) (*domain.User, error) {
	return au.repo.GetUserById(c, id)
}
