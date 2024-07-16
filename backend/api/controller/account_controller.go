package controller

import (
	"back-end/api/controller/model"
	"back-end/internal/domain"
	"back-end/pkg"
	"back-end/util"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type AccountController struct {
	UserUsecase domain.AccountUsecase[domain.LoginModel]
}

// SEND SIGN UP REQUEST AND RETURN ERROR OR TOKEN IF IS REQUEST IS VALIDATED
func (ic *AccountController) SignUpRequest(c *gin.Context) {
	log.Println("RECEVING SIGNUP REQUEST REQUEST")
	log.Println(">>>>>>>>>", c.Request.Body)
	var signupModel domain.SignupModel
	err := c.ShouldBindJSON(&signupModel)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: err.Error()})
		return
	}
	log.Print(signupModel)
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "TEST IS WORKE SUCCESSFULY",
		Data:    signupModel,
	})
}

// SEND LOGIN REQUEST AND RETURN ERROR OR TOKEN IS REQUEST IS VALIDATED
func (ic *AccountController) LoginRequest(c *gin.Context) {
	log.Println("LOGIN POST REQUEST")
	log.Println(">>>>>>>>>", c.Request.Body)
	var loginParms domain.LoginModel
	err := c.ShouldBindJSON(&loginParms)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: err.Error()})
		return
	}
	//TODO: CHECK IF THE LOGING REQUEST SENT BY USERAGNET OR INSURED
	//TODO: USE USERNAME INCLUED IN >>>> LOGIN REQUEST
	id, err := ic.UserUsecase.Login(c, loginParms)
	if err != nil {
		c.JSON(http.StatusOK, model.ErrorResponse{
			Message: err.Error(),
		})
	} else {
		secret := pkg.GET_ROOT_SERVER_SEETING().SECRET_KEY
		role_id, err := ic.UserUsecase.GetRole(c, id)
		role := util.GenerateRole(role_id)
		token, err := util.CreateAccessToken(strconv.FormatInt(id, 10), secret, 2, role)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: err.Error()})
			return
		}
		log.Printf("TOKEN %s", token)
		c.JSON(http.StatusOK, model.SuccessResponse{
			Message: "LOGIN USERT SUCCESSFULY",
			Data:    token,
		})
	}
}
