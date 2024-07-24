package domain

import (
	"context"
	"time"
)

type HtlmlMsg struct {
	FirstName string
	LastName  string
	Code      string
}

type ConfirmationModel struct {
	Code         string      `json:"code"`
	IP           string      `json:"ip"`
	Time_Sending time.Time   `json:"sendingAt"`
	SgnModel     SignupModel `json:"signupModel"`
}
type SignupModel struct {
	UserName  string `json:"username" binding:"required"`
	Phone     string `json:"phone"`
	FirstName string `json:"firstname"`
	LastName  string `json:"lastname"`
	Email     string `json:"email" binding:"required"`
	Role      string `json:"role"`
	PassWord  string `json:"password"`
}

type LoginModel struct {
	UserName string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RestPasswordModel struct {
	UserName    string `form:"username"`
	Email       string `form:"email"`
	NewPassword string `form:"newpassword"`
}

type User struct {
	ID             string `json:"_id"`
	Username       string `json:"username"`
	FirstName      string `json:"firstname"`
	LastName       string `json:"lastname"`
	Email          string `json:"email"`
	Phone          string `json:"phone"`
	PassWord       string `json:"password"`
	Birthdate      string `json:"birthDate"`
	Age            int64  `json:"age"`
	BirthPlace     string `json:"birthPlace"`
	Country        string `json:"country"`
	Municipal      string `json:"municipal"`
	Education      string `json:"education"`
	WorkerAt       string `json:"workerAt"`
	Institution    string `json:"institution"`
	SocialStatus   string `json:"socialStatus"`
	Role           string `json:"role"`
	ProfilePicture string `json:"profilePicture"`
}

type UserRepository interface {
	Login(c context.Context, data *LoginModel) (*User, error)
	SignUp(c context.Context, data *SignupModel) (*User, error)
	// GetRole(c context.Context, data string) (string, error)
	RsetPassword(c context.Context, data *RestPasswordModel) (*User, error)
}

type UserUsecase interface {
	Login(c context.Context, data *LoginModel) (*User, error)
	SignUp(c context.Context, data *SignupModel) (*User, error)
	// GetRole(c context.Context, data string) (string, error)
	RsetPassword(c context.Context, data *RestPasswordModel) (*User, error)
}
