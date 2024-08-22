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

type PaymentController struct {
	WalletUseCase  usecase.WalletUseCase
	PaymentUseCase usecase.PaymentUseCase
	UserUsecase    usecase.UserUsecase
}

func (pc *PaymentController) UpdatePaymentStatusRequest(c *gin.Context) {
	log.Println("__***__***___________ UPDATE CASH OUT WALLET STATUS  REQUEST ___________***__***__")
	var paymentUpdated *domain.Payment
	if !core.IsDataRequestSupported(paymentUpdated, c) {
		return
	}
	log.Println(paymentUpdated)
	paymentParms := &usecase.PaymentParams{}
	paymentParms.Data = paymentUpdated
	resulat := pc.PaymentUseCase.UpdatePaymentStatus(c, paymentParms)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Failed to Update payment status ",
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "UPDATE PYAMENT STATUS REQUEST DONE SUCCESSFULY",
		Data:    resulat.Data,
	})
}
