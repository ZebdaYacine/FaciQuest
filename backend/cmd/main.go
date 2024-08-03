package main

import (
	"back-end/api/server"
	"back-end/cache"
	common "back-end/core"
	"back-end/pkg/database"
	"log"
)

func main() {
	redis, err := cache.CheckRedisConnection()
	if err != nil {
		panic(err)
	}
	// cache.AddKey(rdb, "sed", "opfsdpofdsf", 100*time.Second)
	db := database.ConnectionDb()
	server.InitGinServer(db, redis)
	log.Printf("STRINGING SERVER %s", common.RootServer.SECRET_KEY)
}
