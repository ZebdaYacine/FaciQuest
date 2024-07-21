package controller

import (
	"back-end/api/controller/model"
	"back-end/common"
	"back-end/internal/domain"
	"back-end/util"
	"log"
	"net/http"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

type AccountController struct {
	UserUsecase domain.AccountUsecase[domain.SignupModel]
}

var codeStore = make(map[string]domain.ConfirmationModel)
var mu sync.Mutex

func isDataRequestSupported[T domain.Auth](data *T, c *gin.Context) bool {
	err := c.ShouldBindJSON(&data)
	if err != nil {
		log.Panicf(err.Error())
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Data sent not supported the api format "})
		return false
	}
	return true
}

// HANDLE WITH CONFIRAMTION ACCOUNT REQUEST
func (ac *AccountController) ConfirmeAccountRequest(c *gin.Context) {
	log.Println("_____________________________________RECEVING CONFIRAMTION REQUEST_____________________________________")
	var cnfrMdlRecevied domain.ConfirmationModel
	if !isDataRequestSupported(&cnfrMdlRecevied, c) {
		return
	}
	log.Print(cnfrMdlRecevied)
	clientIP := c.ClientIP()
	mu.Lock()
	cnfrMdlStored, exists := codeStore[clientIP]
	mu.Unlock()
	if !exists {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "No code generated for this client"})
		return
	}
	if cnfrMdlRecevied.Code != cnfrMdlStored.Code {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Invalid code"})
		return
	}
	diff := cnfrMdlRecevied.Time_Sending.Sub(cnfrMdlStored.Time_Sending).Minutes()
	if diff > 5 {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Code expired"})
		return
	}
	insertedID, err := ac.UserUsecase.SignUp(c, &cnfrMdlStored.SgnModel)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: err.Error()})
		return
	}
	token, _ := util.CreateAccessToken(insertedID, common.RootServer.SECRET_KEY, 2, "user")
	log.Printf("TOKEN %s", token)
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "SIGNUP USER SUCCESSFULY",
		Data:    token,
	})
}

// HANDLE WITH SIGNUP REQUEST
func (ic *AccountController) SignUpRequest(c *gin.Context) {
	var signupModel domain.SignupModel
	if !isDataRequestSupported(&signupModel, c) {
		return
	}
	log.Print(signupModel)
	code, err := util.GenerateDigit()
	if err != nil {
		log.Panicf(err.Error())
		c.JSON(500, model.ErrorResponse{Message: err.Error()})
		return
	}
	//SEND EMAIL TO USER WITH CODE
	err = util.SendEmail(signupModel.Email, "Confirme Account", code)
	if err != nil {
		log.Panicf(err.Error())
		c.JSON(500, model.ErrorResponse{Message: "Can't send confirmation code"})
		return
	}
	clientIP := c.ClientIP()
	mu.Lock()
	codeStore[clientIP] = domain.ConfirmationModel{
		Code:         code,
		IP:           clientIP,
		Time_Sending: time.Now(),
		SgnModel:     signupModel,
	}
	mu.Unlock()
	log.Print(codeStore[clientIP])
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "we send six-degit to your email check to confirm you account",
		Data:    signupModel,
	})
}

// // HANDLE WITH LOGIN ACCOUNT REQUEST
func (ic *AccountController) LoginRequest(c *gin.Context) {
	log.Println("LOGIN POST REQUEST")
	var loginParms domain.LoginModel
	if !isDataRequestSupported(&loginParms, c) {
		return
	}
	log.Println(loginParms)
	userId, err := ic.UserUsecase.Login(c, &loginParms)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Incorrect credentials",
		})
	} else {
		secret := common.RootServer.SECRET_KEY
		role_id, _ := ic.UserUsecase.GetRole(c, userId)
		role := util.GenerateRole(role_id)
		token, err := util.CreateAccessToken(userId, secret, 2, role)
		if err != nil {
			c.JSON(500, model.ErrorResponse{Message: err.Error()})
			return
		}
		log.Printf("TOKEN %s", token)
		c.JSON(http.StatusOK, model.SuccessResponse{
			Message: "LOGIN USERT SUCCESSFULY",
			Data:    token,
		})
	}
}
