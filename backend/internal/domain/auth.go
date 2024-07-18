package domain

type Auth interface {
	SignupModel | LoginModel | RestPasswordModel | ConfirmationModel
}
