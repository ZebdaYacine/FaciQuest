package domain

import (
	"time"
)

type ConfirmationModel struct {
	Code         string      `json:"code"`
	IP           string      `json:"ip"`
	Time_Sending time.Time   `json:"sendingAt"`
	SgnModel     SignupModel `json:"signupModel"`
}
type SignupModel struct {
	UserName string `json:"username" binding:"required"`
	Phone    string `json:"phone"`
	Email    string `json:"email" binding:"required"`
	Password string `json:"password"`
}

type LoginModel struct {
	UserName string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RestPasswordModel struct {
	UserName    string `form:"username" binding:"required"`
	Email       string `form:"email" binding:"required"`
	NewPassword string `form:"newpassword" binding:"required"`
}

type AccountRepository[K Auth] interface {
	//Login(c context.Context, data LoginModel) (int64, error)
	//SignUp(c context.Context, siginupRequest *SignupRequest) (SignupResponse, error)
}

type AccountUsecase[K Auth] interface {
	//Login(c context.Context, data LoginModel) (int64, error)
	//SignUp(c context.Context, siginupRequest *SignupRequest) (SignupResponse, error)
	//Login(c context.Context, loginRequest *LoginRequest) (LoginResponse, error)
}
