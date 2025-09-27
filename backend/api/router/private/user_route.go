package private

import (
	"back-end/api/controller"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
	redis "github.com/go-redis/redis/v8"
)

func NewSetNewPwdRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.POST("set-new-pwd", ic.SetNewPwdRequest)
}

func NewSetNewPwdWebRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.POST("set-new-pwd-web", ic.SetNewPwdRequestWeb)
}

func NewUpdateProfileRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.POST("update-profile", ic.UpdateProfileRequest)
}

func NewLogoutRouterRouter(db database.Database, group *gin.RouterGroup, redis *redis.Client) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
		Rdb:         redis,
	}
	group.POST("logout", ic.LogoutRequest)
}
