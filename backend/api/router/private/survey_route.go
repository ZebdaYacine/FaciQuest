package private

import (
	"back-end/api/controller"
	"back-end/core"
	"back-end/internal/repository"
	"back-end/internal/usecase"
	"back-end/pkg/database"

	"github.com/gin-gonic/gin"
)

func NewCreateSurveyRouter(db database.Database, group *gin.RouterGroup) {
	sr := repository.NewSurveyRepository(db)
	su := usecase.NewSurveyUseCase(sr, core.SURVEY)
	sc := &controller.SurveyController{
		SurveyUseCase: su, // usecase for insured operations
	}
	group.POST("create-survey", sc.CreateSurveyRequest)
}

func NewUpdateSurveyRouter(db database.Database, group *gin.RouterGroup) {
	sr := repository.NewSurveyRepository(db)
	su := usecase.NewSurveyUseCase(sr, core.SURVEY)
	sc := &controller.SurveyController{
		SurveyUseCase: su, // usecase for insured operations
	}
	group.POST("update-survey", sc.UpdateSurveyRequest)
}

func NewDeleteSurveyRouter(db database.Database, group *gin.RouterGroup) {
	sr := repository.NewSurveyRepository(db)
	su := usecase.NewSurveyUseCase(sr, core.SURVEY)
	sc := &controller.SurveyController{
		SurveyUseCase: su, // usecase for insured operations
	}
	group.POST("delete-survey", sc.DeleteSurveyRequest)
}

func NewGetSurveyByIdRouter(db database.Database, group *gin.RouterGroup) {
	sr := repository.NewSurveyRepository(db)
	su := usecase.NewSurveyUseCase(sr, core.SURVEY)
	sc := &controller.SurveyController{
		SurveyUseCase: su, // usecase for insured operations
	}
	group.GET("get-survey", sc.GetSurveyRequest)
}

func NewGetMySurveysRouter(db database.Database, group *gin.RouterGroup) {
	sr := repository.NewSurveyRepository(db)
	su := usecase.NewSurveyUseCase(sr, core.SURVEY)
	sc := &controller.SurveyController{
		SurveyUseCase: su, // usecase for insured operations
	}
	group.GET("get-my-surveys", sc.GetMySurveysRequest)
}
