package controller

import (
	"back-end/api/controller/model"
	"back-end/core"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	util "back-end/util/token"
	"log"
	"net/http"
	"strings"

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

	authHeader := c.Request.Header.Get("Authorization")
	tokens := strings.Split(authHeader, " ")
	if len(tokens) < 2 {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Authorization header missing or invalid"})
		return
	}
	token := tokens[1]

	params := usecase.SubmissionParams{}
	params.Data = &new_submission
	claims, err := util.ExtractClaims(token, core.RootServer.SECRET_KEY)
	if err != nil {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{Message: err.Error()})
		return
	}
	params.Data.UserId = claims.ID

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
