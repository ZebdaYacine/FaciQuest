package router

import (
	// "back-end/api/router/public"
	// "database/sql"

	// "github.com/gin-contrib/cors"

	"back-end/api/router/public"
	"database/sql"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func Setup(db *sql.DB, gin *gin.Engine) {

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

	// protectedRouter := gin.Group("/profile")
	// // Middleware to verify AccessToken
	// protectedRouter.Use(middleware.JwtAuthMiddleware(
	// 	pkg.GetServerSetting().SECRET_KEY,
	// 	"Admin"))
	// // All Private APIs
	// //private.NewInsuredRouter(db, protectedRouter)
	// private.NewUserRouter(db, protectedRouter)
}
