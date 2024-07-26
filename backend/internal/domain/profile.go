package domain

import "time"

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
	UserName  string `json:"username"`
	Phone     string `json:"phone"`
	FirstName string `json:"firstname"`
	LastName  string `json:"lastname"`
	Email     string `json:"email"`
	Role      string `json:"role"`
	PassWord  string `json:"password"`
}

type LoginModel struct {
	// UserName string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RestPasswordModel struct {
	// UserName    string `form:"username"`
	Email       string `form:"email"`
	NewPassword string `form:"newpassword"`
}

type ForgetPasswordReqModel struct {
	// UserName    string `form:"username"`
	Email string `form:"email"`
	// NewPassword string `form:"newpassword"`
}

type ForgetPasswordModel struct {
	// UserName    string `form:"username"`
	// Email string `form:"email"`
	NewPassword string `form:"newpassword"`
}
type Account interface {
	SignupModel | LoginModel | ConfirmationModel | RestPasswordModel | User | ForgetPasswordReqModel | ForgetPasswordModel
}
