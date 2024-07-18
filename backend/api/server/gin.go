package server

import (
	"back-end/api/router"
	"back-end/pkg"
	"back-end/pkg/database"
	"log"

	"github.com/gin-gonic/gin"
)

func InitGinServer(db database.Database) {
	//gin.SetMode(gin.ReleaseMode)

	server := gin.Default()

	router.Setup(db, server)
	err := server.Run(pkg.Get_URL())
	if err != nil {
		log.Fatalf("Failed to start server: %v", err)
		return
	}

}
