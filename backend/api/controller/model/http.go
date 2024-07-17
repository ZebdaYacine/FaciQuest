package model

type SuccessResponse struct {
	Message string `json:"message"`
	Data    any    `json:"date"`
}

type ErrorResponse struct {
	Message string `json:"message"`
}
