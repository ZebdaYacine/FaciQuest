package private

import (
	"back-end/api/controller"
	"back-end/internal/domain"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"database/sql"

	"github.com/gin-gonic/gin"
)

func NewUserRouter(db *sql.DB, group *gin.RouterGroup) {
	ur := repository.NewCommonRepository[domain.UserAgent](db)
	uc := &controller.UserController{
		UserUsecase: usecase.NewCommonUsecase[domain.UserAgent](ur, "UserAgent"),
	}
	group.GET("/profile/insured", uc.InsuredReq)
}
