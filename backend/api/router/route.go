package router

import (
	"back-end/api/controller/middleware"
	"back-end/api/router/private"
	"back-end/api/router/public"
	"back-end/pkg"
	"back-end/pkg/database"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func Setup(db database.Database, gin *gin.Engine) {

	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"*"} // Change to your Flutter web app's URL
	config.AllowMethods = []string{"GET", "POST", "PUT", "DELETE"}
	config.AllowHeaders = []string{"Origin", "Content-Type", "Accept", "Authorization"}
	gin.Use(cors.New(config))

	publicRouter := gin.Group("/")

	// All Public APIs
	public.NewTestRouter(db, publicRouter)
	public.NewLoginRouter(db, publicRouter)
	public.NewSignUpRouter(db, publicRouter)
	public.NewConfirmaAccountRouter(db, publicRouter)

	protectedRouter := gin.Group("/profile")
	//Middleware to verify AccessToken
	protectedRouter.Use(middleware.JwtAuthMiddleware(
		pkg.GET_ROOT_SERVER_SEETING().SECRET_KEY,
		"User"))

	private.NewRsetPwdRouter(db, protectedRouter)
}
