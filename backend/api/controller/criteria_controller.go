package controller

import (
	"back-end/api/controller/model"
	"back-end/core"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type CriteriaController struct {
	CriteriaUseCase usecase.CriteriaUseCase
}

func (cc *CriteriaController) CreateCriteriaRequest(c *gin.Context) {
	log.Println("__***__***___________ CREATE CRITERIA  REQUEST ___________***__***__")
	var new_criteria domain.Criteria
	if !core.IsDataRequestSupported(&new_criteria, c) {
		return
	}
	criteriaParams := &usecase.CriteriaParams{}
	criteriaParams.Data = &new_criteria
	result := cc.CriteriaUseCase.CreateCriteria(c, criteriaParams)
	if err := result.Err; err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "CREATE CRITERIA REQUEST DONE SUCCESSFULY",
		Data:    result.Data,
	})
}

func (cc *CriteriaController) GetCriteriasRequest(c *gin.Context) {
	log.Println("__***__***___________ UPDATE CRITERIA  REQUEST ___________***__***__")
	criteriaParams := &usecase.CriteriaParams{}
	criteriaParams.Data = &domain.Criteria{}
	result := cc.CriteriaUseCase.GetCriterias(c, criteriaParams)
	if err := result.Err; err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "GET CRITERIAS REQUEST DONE SUCCESSFULY",
		Data:    result.Data,
	})
}
