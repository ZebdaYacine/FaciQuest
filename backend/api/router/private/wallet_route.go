package private

import (
	"back-end/api/controller"
	"back-end/core"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewGeteWalletRouter(db database.Database, group *gin.RouterGroup) {
	wr := repository.NewWalletRepository(db)
	wu := usecase.NewWalletUsecase(wr, core.WALLET)
	wc := &controller.PaymentController{
		WalletUseCase: wu, // usecase for insured operations
	}
	group.POST("get-wallet", wc.GetWalletRequest)
}

func NewUpdateWalletRouter(db database.Database, group *gin.RouterGroup) {
	wr := repository.NewWalletRepository(db)
	wu := usecase.NewWalletUsecase(wr, core.WALLET)
	wc := &controller.PaymentController{
		WalletUseCase: wu, // usecase for insured operations
	}
	group.POST("update-wallet", wc.UpdateWalletRequest)
}

func NewCashOutWalletRouter(db database.Database, group *gin.RouterGroup) {
	wr := repository.NewWalletRepository(db)
	wu := usecase.NewWalletUsecase(wr, core.WALLET)
	ur := repository.NewUserRepository(db)
	uu := usecase.NewUserUsecase(ur, core.USER)
	wc := &controller.PaymentController{
		WalletUseCase: wu, // usecase for insured operations
		UserUsecase:   uu,
	}
	group.POST("cash-out-wallet", wc.CashOutWalletRequest)
}
