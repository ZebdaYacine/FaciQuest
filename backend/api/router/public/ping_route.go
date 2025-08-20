package public

import (
	"back-end/api/controller"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewPingRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewDashboardRepository(db)
	uc := usecase.NewDashBoardUsecase(ir, "")
	ic := &controller.TestController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.GET("ping", ic.PingRequest)
}
