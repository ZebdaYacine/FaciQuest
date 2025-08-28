package private

import (
	"back-end/api/controller"
	"back-end/core"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewGetUserListRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewDashboardRepository(db)
	cu := usecase.NewDashBoardUsecase(cr, core.SURVEY)
	cc := &controller.DashBoardController{
		DashboardUsecase: cu,
	}
	group.GET("users", cc.GetUsersRequest)
}

func NewGetUserByIDRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewDashboardRepository(db)
	cu := usecase.NewDashBoardUsecase(cr, core.SURVEY)
	cc := &controller.DashBoardController{
		DashboardUsecase: cu,
	}
	group.GET("users/:userId", cc.GetUserByIDRequest)
}

func NewGetAnalyticsRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewDashboardRepository(db)
	cu := usecase.NewDashBoardUsecase(cr, core.SURVEY)
	cc := &controller.DashBoardController{
		DashboardUsecase: cu,
	}
	group.GET("analytics", cc.GetAnalyticsRequest)
}
