package domain

import (
	"context"
)

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
	//AUTH FUNCTIONS
	IsAlreadyExist(c context.Context, data *SignupModel) (bool, error)
	Login(c context.Context, data *LoginModel) (*User, error)
	SignUp(c context.Context, data *SignupModel) (*User, error)
	//SETTING PROFILE FUNCTIONS
	RsetPassword(c context.Context, data *RestPasswordModel) (*User, error)
	UpdateProfile(c context.Context, data *User) (*User, error)
	//WALLET FUNCTIONS
	InitMyWallet(c context.Context, user *User) (*Wallet, error)
	UpdateMyWallet(c context.Context, user *User) (*Wallet, error)
	CheckMyWallet(c context.Context, user *User) (*Wallet, error)
}

type UserUsecase interface {
	//AUTH FUNCTIONS
	IsAlreadyExist(c context.Context, data *SignupModel) (bool, error)
	Login(c context.Context, data *LoginModel) (*User, error)
	SignUp(c context.Context, data *SignupModel) (*User, error)
	//SETTING PROFILE FUNCTIONS
	RsetPassword(c context.Context, data *RestPasswordModel) (*User, error)
	UpdateProfile(c context.Context, data *User) (*User, error)
	//WALLET FUNCTIONS
	InitMyWallet(c context.Context, user *User) (*Wallet, error)
	UpdateMyWallet(c context.Context, user *User) (*Wallet, error)
	CheckMyWallet(c context.Context, user *User) (*Wallet, error)
}
