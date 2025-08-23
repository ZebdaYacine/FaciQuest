package private

import (
	"back-end/api/controller"
	"back-end/core"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewUpdatePaymentStatusRouter(db database.Database, group *gin.RouterGroup) {
	wr := repository.NewWalletRepository(db)
	pr := repository.NewPaymentRepository(db)
	pu := usecase.NewPaymentUseCase(wr, pr, core.PAYMENT, core.WALLET)
	pc := &controller.PaymentController{
		PaymentUseCase: pu,
	}
	group.POST("update-payment-status", pc.UpdatePaymentStatusRequest)
}

func NewGetAllPaymentsRouter(db database.Database, group *gin.RouterGroup) {
	dr := repository.NewDashboardRepository(db)
	du := usecase.NewDashBoardUsecase(dr, core.SURVEY)
	dc := &controller.DashBoardController{
		DashboardUsecase: du,
	}
	group.GET("get-all-payments", dc.GetAllPaymentsRequest)
}
