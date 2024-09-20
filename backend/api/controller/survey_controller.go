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

type SurveyController struct {
	SurveyUseCase usecase.SurveyUseCase
}

func (sc *SurveyController) CreateSurveyRequest(c *gin.Context) {
	log.Println("__***__***___________ CREATE SURVEY  REQUEST ___________***__***__")
	create_survey_request := &domain.Survey{}

	if !core.IsDataRequestSupported(create_survey_request, c) {
		return
	}
	userId := core.GetIdUser(c)
	create_survey_request.UserId = userId
	surveyParams := &usecase.SurveyParams{}
	surveyParams.Data = create_survey_request
	resulat := sc.SurveyUseCase.CreateSurvey(c, surveyParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: resulat.Err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "CREATE SURVEY REQUEST DONE SUCCESSFULY",
		Data:    resulat.Data,
	})
}

func (sc *SurveyController) UpdateSurveyRequest(c *gin.Context) {
	log.Println("__***__***___________ UPDATE SURVEY  REQUEST ___________***__***__")
	create_survey_request := &domain.Survey{}

	if !core.IsDataRequestSupported(create_survey_request, c) {
		return
	}
	userId := core.GetIdUser(c)
	create_survey_request.UserId = userId
	surveyParams := &usecase.SurveyParams{}
	surveyParams.Data = create_survey_request
	resulat := sc.SurveyUseCase.UpdateSurvey(c, surveyParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: resulat.Err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "UPDATE SURVEY REQUEST DONE SUCCESSFULY",
		Data:    resulat.Data,
	})
}
