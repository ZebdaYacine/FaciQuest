package private

import (
	"back-end/api/controller"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewSetNewPwdRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.POST("set-new-pwd", ic.SetNewPwdRequest)
}

func NewUpdateProfileRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.POST("update-profile", ic.UpdateProfileRequest)
}
