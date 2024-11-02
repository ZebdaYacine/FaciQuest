package private

import (
	"back-end/api/controller"
	"back-end/core"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewCreateCollectorRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewCollectorRepository(db)
	cu := usecase.NewColllectorUseCase(cr, core.COLLECTOR)
	cc := &controller.CollectorController{
		CollectorUseCase: cu,
	}
	group.POST("create-collector", cc.CreateCollectorRequest)
}

func NewDeleteCollectorRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewCollectorRepository(db)
	cu := usecase.NewColllectorUseCase(cr, core.COLLECTOR)
	cc := &controller.CollectorController{
		CollectorUseCase: cu,
	}
	group.DELETE("delete-collector", cc.DeleteCollectorRequest)
}

func NewGetCollectorRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewCollectorRepository(db)
	cu := usecase.NewColllectorUseCase(cr, core.COLLECTOR)
	cc := &controller.CollectorController{
		CollectorUseCase: cu,
	}
	group.GET("get-survey-collectors", cc.GetCollectorBySurveyIdRequest)
}

func NewEsstimatePriceByCollectorRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewCollectorRepository(db)
	cu := usecase.NewColllectorUseCase(cr, core.COLLECTOR)
	cc := &controller.CollectorController{
		CollectorUseCase: cu,
	}
	group.GET("estimate-price", cc.EsstimatePriceRequest)
}

func NewConfirmPaymentRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewCollectorRepository(db)
	cu := usecase.NewColllectorUseCase(cr, core.COLLECTOR)
	cc := &controller.CollectorController{
		CollectorUseCase: cu,
	}
	group.GET("confirm-payment", cc.ConfirmPaymentRequest)
}
