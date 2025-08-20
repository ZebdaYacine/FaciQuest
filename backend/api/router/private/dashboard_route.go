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
	group.POST("get-listUsers", cc.GetUsersRequest)
}
