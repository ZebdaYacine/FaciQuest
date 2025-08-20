package controller

import (
	"back-end/api/controller/model"
	"back-end/core"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	"back-end/util/email"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type WalletController struct {
	WalletUseCase  usecase.WalletUseCase
	PaymentUseCase usecase.PaymentUseCase
	UserUsecase    usecase.DashboardUsecase
}

func (wc *PaymentController) UpdateWalletRequest(c *gin.Context) {
	log.Println("__***__***___________ UPDATE WALLET  REQUEST ___________***__***__")
	var WalletUpdated domain.Wallet
	if !core.IsDataRequestSupported(&WalletUpdated, c) {
		return
	}
	WalletUpdated.UserID = core.GetIdUser(c)
	log.Println(WalletUpdated)
	walletParams := &usecase.WalletParams{}
	walletParams.Data = WalletUpdated
	resulat := wc.WalletUseCase.UpdateMyWallet(c, walletParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Failed to Update Wallet",
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "UPDATE WALLET REQUEST DONE SUCCESSFULY",
		Data:    resulat.Data.(*domain.Wallet),
	})
}

func (pc *PaymentController) GetWalletRequest(c *gin.Context) {
	log.Println("__***__***___________ GET WALLET  REQUEST ___________***__***__")
	walletParams := &usecase.WalletParams{}
	println(core.GetIdUser(c))
	walletParams.Data = core.GetIdUser(c)
	resulat := pc.WalletUseCase.GetWallet(c, walletParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: resulat.Err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "GET WALLET REQUEST DONE SUCCESSFULY",
		Data:    resulat.Data.(*domain.Wallet),
	})
}

func (wc *PaymentController) CashOutWalletRequest(c *gin.Context) {
	log.Println("__***__***___________ CASH OUT WALLET  REQUEST ___________***__***__")
	var payment_request domain.Payment
	if !core.IsDataRequestSupported(&payment_request, c) {
		return
	}
	userId := core.GetIdUser(c)
	payment_request.Wallet.UserID = userId
	paymentRequestParams := &usecase.PaymentParams{}
	paymentRequestParams.Data = &payment_request
	resulat := wc.PaymentUseCase.PaymentRequest(c, paymentRequestParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: resulat.Err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "WALLET CASH OUT REQUEST DONE SUCCESSFULY",
		Data:    resulat.Data,
	})
	user, err := wc.UserUsecase.GetUserById(c, userId)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: err.Error(),
		})
		return
	}
	subject := "Cash out request recived"
	body := fmt.Sprintf(" Your request to cash out  %.2f DZD is being processed.\n request id:%s", payment_request.Amount, payment_request.ID)
	email.SendEmail(user.Email, subject, body)

}
