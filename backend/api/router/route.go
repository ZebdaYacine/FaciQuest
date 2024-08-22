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

	protectedRouter := gin.Group("/profile")

	//Middleware to verify AccessToken
	protectedRouter.Use(middleware.JwtAuthMiddleware(
		pkg.GET_ROOT_SERVER_SEETING().SECRET_KEY,
		"User"))

	//Middleware to verify is token in black list
	protectedRouter.Use(middleware.JwtBlackListMiddleware(redis))

	// All Private APIs
	private.NewSetNewPwdRouter(db, protectedRouter)
	private.NewUpdateProfileRouter(db, protectedRouter)
	private.NewLogoutRouterRouter(db, protectedRouter, redis)

	private.NewGeteWalletRouter(db, protectedRouter)
	private.NewUpdateWalletRouter(db, protectedRouter)
	private.NewCashOutWalletRouter(db, protectedRouter)

	//Middleware to verify AccessToken
	protectedRouter.Use(middleware.JwtAuthMiddleware(
		pkg.GET_ROOT_SERVER_SEETING().SECRET_KEY,
		"Admin"))
	private.NewUpdatePaymentStatusRouter(db, protectedRouter)

}
