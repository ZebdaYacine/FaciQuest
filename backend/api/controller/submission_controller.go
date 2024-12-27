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

type SubmissionController struct {
	SubmissionUseCase usecase.SubmissionUseCase
}

func (cc *SubmissionController) CreateSubmissionRequest(c *gin.Context) {
	log.Println("__***__***___________ CREATE SUBMISSION  REQUEST ___________***__***__")
	var new_submission domain.Submission
	if !core.IsDataRequestSupported(&new_submission, c) {
		return
	}
	params := usecase.SubmissionParams{}
	params.Data = &new_submission
	result := cc.SubmissionUseCase.CreateNewSubmission(c, &params)
	if result.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: result.Err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "CREATE SUBMISSION REQUEST DONE SUCCESSFULY",
		Data:    result.Data,
	})
}

func (cc *SubmissionController) GetAnswersRequest(c *gin.Context) {
	log.Println("__***__***___________ GET ANSWERS  REQUEST ___________***__***__")
	var answer domain.SurCol
	if !core.IsDataRequestSupported(&answer, c) {
		return
	}
	params := usecase.AnswersParams{}
	params.SurveyID = answer.SurveyID
	params.CollectorID = answer.CollectorID
	cc.SubmissionUseCase.GetAnswers(c, &params)
	result := cc.SubmissionUseCase.GetAnswers(c, &params)
	if result.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: result.Err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "GET ANSWERS  DONE SUCCESSFULY",
		Data:    result.Data,
	})
}
