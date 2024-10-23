package private

import (
	"back-end/api/controller"
	"back-end/core"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewSubmissionAnswerRouter(db database.Database, group *gin.RouterGroup) {
	sr := repository.NewSubmissionRepository(db)
	su := usecase.NewSubmissionUseCase(sr, core.SUBMISSION)
	sc := &controller.SubmissionController{
		SubmissionUseCase: su,
	}
	group.POST("submit-answer", sc.CreateSubmissionRequest)
}
