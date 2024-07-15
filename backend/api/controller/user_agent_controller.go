package controller

import (
	"back-end/api/controller/model"
	"back-end/internal/domain"
	"net/http"

	"github.com/gin-gonic/gin"
)

type UserController struct {
	UserUsecase domain.CommonUsecase[domain.UserAgent]
}

func (uc *UserController) InsuredReq(c *gin.Context) {
	var req model.Request[domain.Insured]
	err := c.ShouldBindJSON(&req)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: err.Error()})
		return
	}
	action := req.Action
	switch action {
	case "create":
		CreateInsured(uc, req.Data, c)
		break
	case "delete":
		break
	case "update":
		break
	default:
		c.JSON(http.StatusOK, model.ErrorResponse{
			Message: "Invalid action",
		})
	}
}

func CreateInsured(uc *UserController, data domain.Insured, c *gin.Context) {
	err := uc.UserUsecase.CreateInsured(c, data)
	if err != nil {
		c.JSON(http.StatusOK, model.ErrorResponse{
			Message: err.Error(),
		})
	} else {
		c.JSON(http.StatusOK, model.SuccessResponse{
			Message: "Insured created successfully",
			Data:    data,
		})
	}
}
