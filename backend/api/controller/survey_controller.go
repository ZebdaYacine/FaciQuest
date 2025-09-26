package controller

import (
	"back-end/api/controller/model"
	"back-end/core"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"

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
	update_survey_request := &domain.Survey{}

	if !core.IsDataRequestSupported(update_survey_request, c) {
		return
	}
	userId := core.GetIdUser(c)
	update_survey_request.SurveyBadge.UserId = userId
	surveyParams := &usecase.SurveyParams{}
	surveyParams.Data = update_survey_request
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
	userId := core.GetIdUser(c)
	result := sc.SurveyUseCase.GetAllSurveys(c, userId)
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

// UpdateSurveyStatusRequest handles updating a survey status by admin
func (sc *SurveyController) UpdateSurveyStatusRequest(c *gin.Context) {
	surveyID := c.Param("surveyId")
	if surveyID == "" {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "surveyId is required"})
		return
	}
	var body struct {
		Status string `json:"status"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid body"})
		return
	}
	ok := sc.SurveyUseCase.UpdateSurveyStatus(c, surveyID, body.Status)
	if ok.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: ok.Err.Error()})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{Message: "UPDATE SURVEY STATUS REQUEST DONE SUCCESSFULY", Data: ok.Value})
}

// GetAdminSurveysRequest handles admin surveys listing with filters
func (sc *SurveyController) GetAdminSurveysRequest(c *gin.Context) {
	q := c.Request.URL.Query()

	var (
		limitPtr  *int
		offsetPtr *int
		status    string
		startAt   *time.Time
		endAt     *time.Time
	)

	if lv := q.Get("limit"); lv != "" {
		if v, err := strconv.Atoi(lv); err == nil {
			limitPtr = &v
		} else {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid limit"})
			return
		}
	}
	if pv := q.Get("page"); pv != "" {
		page, err := strconv.Atoi(pv)
		if err != nil || page <= 0 {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid page"})
			return
		}
		l := 50
		if limitPtr != nil {
			l = *limitPtr
		}
		off := (page - 1) * l
		offsetPtr = &off
		if limitPtr == nil {
			limitPtr = &l
		}
	}
	status = q.Get("status")
	if status != "" && status != "draft" && status != "active" && status != "closed" {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid status"})
		return
	}
	if s := q.Get("start_date"); s != "" {
		t, err := time.Parse(time.RFC3339, s)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid start_date"})
			return
		}
		startAt = &t
	}
	if s := q.Get("end_date"); s != "" {
		t, err := time.Parse(time.RFC3339, s)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid end_date"})
			return
		}
		endAt = &t
	}

	params := usecase.AdminSurveyListParams{Status: status, Limit: limitPtr, Offset: offsetPtr, StartAt: startAt, EndAt: endAt}
	result := sc.SurveyUseCase.GetAdminSurveys(c, params)
	if err := result.Err; err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: err.Error()})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{Message: "GET ADMIN SURVEYS REQUEST DONE SUCCESSFULY", Data: result.List})
}
