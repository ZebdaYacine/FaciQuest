package server

import (
	"back-end/api/router"
	"back-end/pkg"
	"back-end/pkg/database"
	"log"

	"github.com/gin-gonic/gin"
	redis "github.com/go-redis/redis/v8"
)

func InitGinServer(db database.Database, redis *redis.Client) {
	//gin.SetMode(gin.ReleaseMode)

	server := gin.Default()

	router.Setup(db, server, redis)
	err := server.Run(pkg.Get_URL())
	if err != nil {
		log.Fatalf("Failed to start server: %v", err)
		return
	}

}
