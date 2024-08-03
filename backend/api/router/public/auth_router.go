package public

import (
	"back-end/api/controller"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewConfirmaAccountRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	wr := repository.NewWalletRepository(db)
	wc := usecase.NewWalletUsecase(wr, "")
	ic := &controller.AccountController{
		UserUsecase:   uc,
		WalletUseCase: wc,
	}
	group.POST("confirm-account", ic.ConfirmeAccountRequest)
}

func NewForgetPwdRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.POST("forget-pwd", ic.ForgetPwdRequest)
}

func NewLoginRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.POST("login", ic.LoginRequest)
}

func NewSignUpRouter(db database.Database, group *gin.RouterGroup) {
	ir := repository.NewUserRepository(db)
	uc := usecase.NewUserUsecase(ir, "")
	ic := &controller.AccountController{
		UserUsecase: uc, // usecase for insured operations
	}
	group.POST("sign-up", ic.SignUpRequest)
}
