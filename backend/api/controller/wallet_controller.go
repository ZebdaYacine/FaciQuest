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
	WalletUseCase usecase.WalletUseCase
	UserUsecase   usecase.UserUsecase
}

func (wc *WalletController) UpdateCashOutMyWalletRequest(c *gin.Context) {
	log.Println("__***__***___________ UPDATE CASH OUT WALLET STATUS  REQUEST ___________***__***__")
	var CashOutUpdated *domain.CashOut
	if !core.IsDataRequestSupported(CashOutUpdated, c) {
		return
	}
	log.Println(CashOutUpdated)
	cashOutParams := &usecase.CashOutMyWalletParams{}
	cashOutParams.Data = CashOutUpdated
	resulat := wc.WalletUseCase.UpdateCashOutStatus(c, cashOutParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Failed to Update Wallet",
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "UPDATE WALLET REQUEST DONE SUCCESSFULY",
		Data:    resulat.Data,
	})
}

func (wc *WalletController) UpdateWalletRequest(c *gin.Context) {
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

func (wc *WalletController) GetWalletRequest(c *gin.Context) {
	log.Println("__***__***___________ GET WALLET  REQUEST ___________***__***__")
	walletParams := &usecase.WalletParams{}
	println(core.GetIdUser(c))
	walletParams.Data = core.GetIdUser(c)
	resulat := wc.WalletUseCase.GetWallet(c, walletParams)
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

func (wc *WalletController) CashOutWalletRequest(c *gin.Context) {
	log.Println("__***__***___________ CASH OUT WALLET  REQUEST ___________***__***__")
	var cash_out domain.CashOut
	if !core.IsDataRequestSupported(&cash_out, c) {
		return
	}
	userId := core.GetIdUser(c)
	cash_out.Wallet.UserID = userId
	cashOutMyWalletParams := &usecase.CashOutMyWalletParams{}
	cashOutMyWalletParams.Data = &cash_out
	resulat := wc.WalletUseCase.CashOutMyWallet(c, cashOutMyWalletParams)
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
	body := "Your request to cash out " + fmt.Sprintf("%.2f", cash_out.Amount) + " DZD is being processed.\n request id:" + fmt.Sprintf("%s", cash_out.ID)
	email.SendEmail(user.Email, subject, body)

}
