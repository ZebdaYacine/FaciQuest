package controller

import (
	"back-end/api/controller/model"
	"back-end/core"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	"fmt"
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

func (sc *SurveyController) DeleteSurveyRequest(c *gin.Context) {
	log.Println("__***__***___________ DELETE SURVEY  REQUEST ___________***__***__")
	var DeleteSurvey domain.GetBySurveyIdModel
	survey := &domain.Survey{}
	if !core.IsDataRequestSupported(&DeleteSurvey, c) {
		return
	}
	userId := core.GetIdUser(c)
	survey.ID = DeleteSurvey.SurveyId
	survey.UserId = userId
	surveyParams := &usecase.SurveyParams{}
	surveyParams.Data = survey
	log.Println(surveyParams.Data)
	resulat, err := sc.SurveyUseCase.DeleteSurvey(c, surveyParams)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "DELETE SURVEY REQUEST DONE SUCCESSFULY",
		Data:    resulat,
	})
}

func (sc *SurveyController) GetSurveyRequest(c *gin.Context) {
	log.Println("__***__***___________ GET SURVEY  REQUEST ___________***__***__")
	var Survey domain.GetBySurveyIdModel
	survey := &domain.Survey{}
	if !core.IsDataRequestSupported(&Survey, c) {
		return
	}
	userId := core.GetIdUser(c)
	survey.ID = Survey.SurveyId
	survey.UserId = userId
	surveyParams := &usecase.SurveyParams{}
	surveyParams.Data = survey
	result := sc.SurveyUseCase.GetSurveyById(c, surveyParams)
	if err := result.Err; err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "GET SURVEY BY ID REQUEST DONE SUCCESSFULY",
		Data:    result.Data,
	})
}

func (sc *SurveyController) GetMySurveysRequest(c *gin.Context) {
	log.Println("__***__***___________ GET MY SURVEYS  REQUEST ___________***__***__")
	userId := core.GetIdUser(c)
	fmt.Println("userId : ", userId)
	surveyParams := &usecase.SurveyParams{}
	survey := &domain.Survey{}
	survey.UserId = userId
	surveyParams.Data = survey
	result := sc.SurveyUseCase.GetMySurveys(c, surveyParams)
	if err := result.Err; err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: err.Error(),
		})
		return
	}
	log.Println(result)

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "GET MY SURVEYS REQUEST DONE SUCCESSFULY",
		Data:    result.List,
	})
}

func (sc *SurveyController) GetAllSurveysRequest(c *gin.Context) {
	log.Println("__***__***___________ GET All SURVEYS  REQUEST ___________***__***__")
	result := sc.SurveyUseCase.GetAllSurveys(c)
	if err := result.Err; err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "GET ALL SURVEYS REQUEST DONE SUCCESSFULY",
		Data:    result.List,
	})
}

// GetSurveysByStatusRequest handles listing surveys filtered by status
func (sc *SurveyController) GetSurveysByStatusRequest(c *gin.Context) {
	status := c.Query("status")
	result := sc.SurveyUseCase.GetSurveysByStatus(c, status)
	if err := result.Err; err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: err.Error()})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{Message: "GET SURVEYS BY STATUS REQUEST DONE SUCCESSFULY", Data: result.List})
}
