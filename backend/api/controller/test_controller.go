package controller

import (
	"back-end/api/controller/model"
	"back-end/internal/domain"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type TestController struct {
	UserUsecase domain.AccountUsecase[domain.LoginModel]
}

func (ic *TestController) TestRequest(c *gin.Context) {
	log.Println(">>>>>>>>>", c.Request.Body)
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "TEST IS WORKE SUCCESSFULY",
		Data:    ".......",
	})
}
