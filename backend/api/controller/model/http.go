package model

type Response struct {
	Token    string `json:"token"`
	UserData any    `json:"userdata"`
}

type SuccessResponse struct {
	Message string `json:"message"`
	Data    any    `json:"date"`
}

type ErrorResponse struct {
	Message string `json:"message"`
}
