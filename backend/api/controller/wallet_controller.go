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

type WalletController struct {
	WalletUseCase usecase.WalletUseCase
}

func (wc *WalletController) UpdateWalletRequest(c *gin.Context) {
	log.Println("__***__***___________ UPDATE WALLET  REQUEST ___________***__***__")
	var WalletUpdated domain.Wallet
	if !core.IsDataRequestSupported(&WalletUpdated, c) {
		return
	}
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
		Data:    resulat.Data,
	})
}
