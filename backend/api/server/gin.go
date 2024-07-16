package server

import (
	"back-end/api/router"
	"back-end/pkg"
	"database/sql"
	"log"

	"github.com/gin-gonic/gin"
)

func InitGinServer(db *sql.DB) {
	//gin.SetMode(gin.ReleaseMode)

	server := gin.Default()

	router.Setup(db, server)
	err := server.Run(pkg.Get_URL())
	if err != nil {
		log.Fatalf("Failed to start server: %v", err)
		return
	}

}
