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

// type Form struct {
// 	Pwd string `json:"pwd"`
// }

// func formHandler(c *gin.Context) {
// 	// Get form values
// 	test := Form{
// 		Pwd: "",
// 	}
// 	err := c.ShouldBindJSON(&test)
// 	if err != nil {
// 		log.Panicf(err.Error())
// 		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Data sent not supported the api format "})
// 	}
// 	c.JSON(200, test.Pwd)
// }

// func main() {
// 	r := gin.Default()
// 	r.POST("/forget-pwd", formHandler)
// 	r.Run(":3000") // listen and serve on 0.0.0.0:8080
// }
