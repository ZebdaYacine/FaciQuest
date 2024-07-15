package model

import "back-end/internal/domain"

type Request[T domain.Person] struct {
	Data   T      `form:"data" binding:"required"`
	Action string `form:"action" binding:"required"`
}

type SuccessResponse struct {
	Message string `json:"message"`
	Data    any    `json:"date"`
}

type ErrorResponse struct {
	Message string `json:"message"`
}
