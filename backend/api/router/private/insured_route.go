package private

import (
	"database/sql"

	"github.com/gin-gonic/gin"
)

func NewInsuredRouter(db *sql.DB, group *gin.RouterGroup) {
	// ir := repository.NewCommonRepository[domain.Insured](db)
	// uc := usecase.NewCommonUsecase[domain.Insured](ir, "Insured")
	// ic := &controller.InsuredController{
	// 	Iu: uc, // usecase for insured operations
	// }
	// group.GET("/insured/create", ic.CreateUserRequest)
	// group.GET("/insured/update", ic.UpdateUserRequest)
}
