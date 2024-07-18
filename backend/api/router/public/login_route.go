package public

import (
	"back-end/api/controller"
	"back-end/internal/domain"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewLoginRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewAccountRepository[domain.LoginModel](db)
	uc := usecase.NewAccountUsecase[domain.LoginModel](ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.POST("login", ic.LoginRequest)
}
