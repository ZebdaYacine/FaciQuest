package controller

import (
	"back-end/internal/domain"
)

type InsuredController struct {
	Iu domain.CommonUsecase[domain.Insured]
}
