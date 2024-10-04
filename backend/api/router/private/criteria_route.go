package private

import (
	"back-end/api/controller"
	"back-end/core"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewCreateCriteriaRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewCriteriaRepository(db)
	cu := usecase.NewCriteriaUseCase(cr, core.SURVEY)
	cc := &controller.CriteriaController{
		CriteriaUseCase: cu,
	}
	group.POST("create-criteria", cc.CreateCriteriaRequest)
}

func NewGetCriteriaRouter(db database.Database, group *gin.RouterGroup) {
	cr := repository.NewCriteriaRepository(db)
	cu := usecase.NewCriteriaUseCase(cr, core.SURVEY)
	cc := &controller.CriteriaController{
		CriteriaUseCase: cu,
	}
	group.GET("get-criterias", cc.GetCriteriasRequest)
}
