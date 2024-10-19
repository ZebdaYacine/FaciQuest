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
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "CREATE COLLECTOR REQUEST DONE SUCCESSFULY",
		Data:    nil,
	})
}

func (cc *CollectorController) DeleteCollectorRequest(c *gin.Context) {
	log.Println("__***__***___________ DELETE COLLECTOR  REQUEST ___________***__***__")
	var new_collector domain.Collector
	if !core.IsDataRequestSupported(&new_collector, c) {
		return
	}
	log.Println(new_collector)
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "DELETE COLLECTOR REQUEST DONE SUCCESSFULY",
		Data:    nil,
	})
}
