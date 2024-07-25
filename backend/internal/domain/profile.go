package domain

type Account interface {
	SignupModel | LoginModel | ConfirmationModel | RestPasswordModel | User
}
