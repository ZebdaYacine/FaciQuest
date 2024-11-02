package controller

import (
	"back-end/api/controller/model"
	"back-end/core"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	"encoding/base64"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type CollectorController struct {
	CollectorUseCase usecase.CollectorUseCase
}

func (cc *CollectorController) CreateCollectorRequest(c *gin.Context) {
	log.Println("__***__***___________ CREATE COLLECTOR  REQUEST ___________***__***__")
	var new_collector domain.Collector
	if !core.IsDataRequestSupported(&new_collector, c) {
		return
	}
	log.Println(new_collector)
	params := usecase.CollectorParams{}
	params.Data = &new_collector
	result := cc.CollectorUseCase.CreateCollector(c, &params)
	if result.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: result.Err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "CREATE COLLECTOR REQUEST DONE SUCCESSFULY",
		Data:    new_collector,
	})
}

func (cc *CollectorController) DeleteCollectorRequest(c *gin.Context) {
	log.Println("__***__***___________ DELETE COLLECTOR  REQUEST ___________***__***__")
	var new_collector domain.Collector
	if !core.IsDataRequestSupported(&new_collector, c) {
		return
	}
	log.Println(new_collector)
	params := usecase.CollectorParams{}
	params.Data = &new_collector
	result, err := cc.CollectorUseCase.DeleteCollector(c, &params)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "DELETE COLLECTOR REQUEST DONE SUCCESSFULY",
		Data:    result,
	})
}

func (cc *CollectorController) GetCollectorBySurveyIdRequest(c *gin.Context) {
	log.Println("__***__***___________ GET COLLECTOR BY SUREVY ID REQUEST ___________***__***__")
	var survey domain.GetBySurveyIdModel
	if !core.IsDataRequestSupported(&survey, c) {
		return
	}
	new_collector := domain.Collector{}
	new_collector.SurveyId = survey.SurveyId
	params := usecase.CollectorParams{}
	params.Data = &new_collector
	result := cc.CollectorUseCase.GetCollector(c, &params)
	if result.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: result.Err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "GET COLLECTOR BY SUREVY ID REQUEST DONE SUCCESSFULY",
		Data:    result.Data,
	})
}

func (cc *CollectorController) EsstimatePriceRequest(c *gin.Context) {
	log.Println("__***__***___________ Estimate Price REQUEST ___________***__***__")
	var new_collector domain.Collector
	if !core.IsDataRequestSupported(&new_collector, c) {
		return
	}
	params := &usecase.CollectorParams{}
	params.Data = &new_collector
	result, err := cc.CollectorUseCase.EstimatePriceByCollector(c, params.Data)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "ESTIMATE PRICE REQUEST DONE SUCCESSFULY",
		Data:    result,
	})
}

func (cc *CollectorController) ConfirmPaymentRequest(c *gin.Context) {
	log.Println("__***__***___________ Confirm Payment REQUEST ___________***__***__")
	var new_cofirm_payment domain.ConfirmPayment
	if !core.IsDataRequestSupported(&new_cofirm_payment, c) {
		return
	}
	decodedData, err := base64.StdEncoding.DecodeString(new_cofirm_payment.ProofOfPayment)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Failed to decode Base64 data"})
		return
	}
	log.Println(decodedData)
	result := cc.CollectorUseCase.ConfirmPayment(c, &new_cofirm_payment)
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "ESSTIMATE PRICE REQUEST DONE SUCCESSFULY",
		Data:    result,
	})
}
