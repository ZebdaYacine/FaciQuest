package private

import (
	"back-end/api/controller"
	"back-end/core"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewPaymentRouter(db database.Database, group *gin.RouterGroup) {
	wr := repository.NewWalletRepository(db)
	pr := repository.NewPaymentRepository(db)
	pu := usecase.NewPaymentUseCase(wr, pr, core.PAYMENT, core.WALLET)
	pc := &controller.PaymentController{
		PaymentUseCase: pu,
	}
	group.POST("update-payment-status", pc.UpdatePaymentStatusRequest)
}
