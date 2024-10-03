package controller

import (
	"back-end/api/controller/model"
	"back-end/internal/usecase"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type TestController struct {
	UserUsecase usecase.UserUsecase
}

func (ic *TestController) PingRequest(c *gin.Context) {
	log.Println("__________________________RECEVING PING REQUEST__________________________")
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "PING IS WORKE SUCCESSFULY",
		Data:    "WESH CV.....!!!",
	})
	//insertedID, err := ic.UserUsecase.SignUp(c&{})
}
