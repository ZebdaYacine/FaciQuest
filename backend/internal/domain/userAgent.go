package domain

import (
	"context"
)

type UserAgent struct {
	Id       int64  `json:"id" binding:"required"`
	UserName string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
	Role_ID  int    `json:"role" binding:"required"`
}

type Insured struct {
	Id        int64  `json:"id" binding:"required"`
	FirstName string `json:"username" binding:"required"`
}

type CommonRepository[T Person] interface {
	CreateInsured(c context.Context, data Insured) error
	UpdateInsured(c context.Context, data Insured) error
	//SignUp(c context.Context, siginupRequest *SignupRequest) (SignupResponse, error)
	//Login(c context.Context, loginRequest *LoginRequest) (LoginResponse, error)
}

type CommonUsecase[T Person] interface {
	CreateInsured(c context.Context, data Insured) error
	UpdateInsured(c context.Context, data Insured) error
	//SignUp(c context.Context, siginupRequest *SignupRequest) (SignupResponse, error)
	//Login(c context.Context, loginRequest *LoginRequest) (LoginResponse, error)
}
