package main

import (
	"back-end/api/server"
	"back-end/pkg/database"
)

func main() {
	db := database.ConnectionDb()
	server.InitGinServer(db)
	//log.Println("STRINGING SERVER %s", Shared.RootServer.SECRET_KEY)
}

// package main

// import (
// 	"back-end/api/controller/model"
// 	"back-end/internal/domain"
// 	"encoding/json"
// 	"log"
// 	"net/http"

// 	"github.com/gin-gonic/gin"
// )

// func main() {
// 	router := gin.Default()

// 	// Enable CORS
// 	router.Use(func(c *gin.Context) {
// 		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
// 		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT")
// 		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
// 		if c.Request.Method == "OPTIONS" {
// 			c.AbortWithStatus(204)
// 			return
// 		}
// 		c.Next()
// 	})

// 	// Define your routes
// 	router.GET("/login", func(c *gin.Context) {
// 		log.Println(c.PostForm("dd"))
// 		var tt domain.LoginModel
// 		json.Unmarshal([]byte(c.PostForm("dd")), tt)
// 		log.Println(tt)

// 		// username := c.Query("username")
// 		// email := c.Query("email")
// 		// password := c.Query("password")
// 		// log.Printf("Username: %s, Email: %s, Password: %s", username, email, password)
// 		// log.Print(c.Request.Body)
// 		c.JSON(http.StatusOK, gin.H{"message": "Login successful", "data": tt})
// 	})

// 	router.GET("/", func(c *gin.Context) {
// 		var json domain.LoginModel
// 		log.Println(c.GetPostForm("email"))
// 		c.ShouldBindJSON(&json)
// 		log.Println(">>>>>>>>> %s: ", json.Password)
// 		c.JSON(http.StatusOK, model.SuccessResponse{
// 			Message: "TEST IS WORKE SUCCESSFULY",
// 			Data:    ".......",
// 		})
// 	})

// 	router.Run("127.0.0.1:3005")
// }
