package domain

import "time"

type ConfirmationModel struct {
	Reason       string      `json:"reason"`
	Code         string      `json:"code"`
	IP           string      `json:"ip"`
	Time_Sending time.Time   `json:"sendingAt"`
	SgnModel     SignupModel `json:"signupModel"`
}

type SignupModel struct {
	Id        string `json:"_id"`
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

type SetNewPasswordModel struct {
	// UserName    string `form:"username"`
	Pin         string `form:"pin"`
	NewPassword string `form:"newpassword"`
}

type ForgetPasswordModel struct {
	// UserName    string `form:"username"`
	Email string `form:"email"`
	// NewPassword string `form:"newpassword"`
}

type GetBySurveyIdModel struct {
	SurveyId string `json:"surveyId"`
}

type Account interface {
	SignupModel | LoginModel | ConfirmationModel |
		Wallet | SetNewPasswordModel | User |
		ForgetPasswordModel | Payment |
		Survey | GetBySurveyIdModel | SurveyBadge |
		Criteria | Collector | Submission | ConfirmPayment |
		SurCol
}
