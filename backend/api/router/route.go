package router

import (
	"back-end/api/controller/middleware"
	"back-end/api/router/private"
	"back-end/api/router/public"
	"back-end/pkg"
	"back-end/pkg/database"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	redis "github.com/go-redis/redis/v8"
)

func Setup(db database.Database, gin *gin.Engine, redis *redis.Client) {

	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"*"} // Change to your Flutter web app's URL
	config.AllowMethods = []string{"GET", "POST", "PUT", "DELETE"}
	config.AllowHeaders = []string{"Origin", "Content-Type", "Accept", "Authorization"}
	gin.Use(cors.New(config))

	publicRouter := gin.Group("/")

	// All Public APIs
	public.NewPingRouter(db, publicRouter)
	public.NewLoginRouter(db, publicRouter)
	public.NewSignUpRouter(db, publicRouter)
	public.NewConfirmaAccountRouter(db, publicRouter)
	public.NewForgetPwdRouter(db, publicRouter)

	userRouter := gin.Group("/profile")

	//Middleware to verify AccessToken
	userRouter.Use(middleware.JwtAuthMiddleware(
		pkg.GET_ROOT_SERVER_SEETING().SECRET_KEY,
		"User"))

	//Middleware to verify is token in black list
	// userRouter.Use(middleware.JwtBlackListMiddleware(redis))

	// All Private APIs

	//Auth API
	private.NewSetNewPwdRouter(db, userRouter)
	private.NewUpdateProfileRouter(db, userRouter)
	private.NewLogoutRouterRouter(db, userRouter, redis)
	//Wallet API
	private.NewUpdateWalletRouter(db, userRouter)
	private.NewCashOutWalletRouter(db, userRouter)
	//Survey API
	private.NewCreateSurveyRouter(db, userRouter)
	private.NewUpdateSurveyRouter(db, userRouter)
	private.NewDeleteSurveyRouter(db, userRouter)
	private.NewGetSurveyByIdRouter(db, userRouter)
	private.NewGetMySurveysRouter(db, userRouter)
	private.NewGetAllSurveysRouter(db, userRouter)
	//Criteria API
	private.NewGetCriteriaRouter(db, userRouter)
	private.NewCreateCriteriaRouter(db, userRouter)
	//Collector API
	private.NewCreateCollectorRouter(db, userRouter)
	private.NewDeleteCollectorRouter(db, userRouter)
	private.NewGetCollectorBySurveyIDRouter(db, userRouter)
	private.NewEsstimatePriceByCollectorRouter(db, userRouter)
	private.NewConfirmPaymentRouter(db, userRouter)
	//Submission API
	private.NewSubmissionAnswerRouter(db, userRouter)
	private.GetAnswersRouter(db, userRouter)

	adminRouter := gin.Group("/admin")

	//Middleware to verify AccessToken
	adminRouter.Use(middleware.JwtAuthMiddleware(
		pkg.GET_ROOT_SERVER_SEETING().SECRET_KEY,
		"Admin"))
	private.NewUpdatePaymentStatusRouter(db, adminRouter)
	private.NewGetAllPaymentsRouter(db, adminRouter)
	private.NewCreateCriteriaRouter(db, adminRouter)
	private.NewGetUserListRouter(db, adminRouter)
	private.NewGetUserByIDRouter(db, adminRouter)
	private.NewGetSurveysByStatusRouter(db, adminRouter)
	private.NewUpdateSurveyStatusRouter(db, adminRouter)
	private.NewGetAdminSurveysRouter(db, adminRouter)
	private.NewGetSurveyByIdRouter(db, adminRouter)
	private.NewGetAnalyticsRouter(db, adminRouter)

}
