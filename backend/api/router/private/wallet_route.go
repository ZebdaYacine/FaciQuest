package private

import (
	"back-end/api/controller"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewUpdateWalletRouter(db database.Database, group *gin.RouterGroup) {
	wr := repository.NewWalletRepository(db)
	wu := usecase.NewWalletUsecase(wr, "")
	wc := &controller.WalletController{
		WalletUseCase: wu, // usecase for insured operations
	}
	group.POST("update-wallet", wc.UpdateWalletRequest)
}
