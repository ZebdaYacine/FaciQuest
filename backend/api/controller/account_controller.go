package controller

import (
	"back-end/api/controller/model"
	"back-end/internal/domain"
	"back-end/pkg"
	"back-end/util"
	"log"
	"net/http"
	"strconv"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

type AccountController struct {
	UserUsecase domain.AccountUsecase[domain.LoginModel]
}

var codeStore = make(map[string]domain.ConfirmationModel)
var mu sync.Mutex

func isDataRequestSupported[T domain.Auth](data *T, c *gin.Context) bool {
	err := c.ShouldBindJSON(&data)
	if err != nil {
		log.Panicf(err.Error())
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "data not supported"})
		return false
	}
	return true
}

// HANDLE WITH CONFIRAMTION ACCOUNT REQUEST
func (ic *AccountController) ConfirmeAccountRequest(c *gin.Context) {
	log.Println(">>>>>>>>>>>>>>>>>>>>>>>>>>> RECEVING CONFIRAMTION REQUEST")
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
	log.Println(">>>>>>>>>>>>>>>>>>>>>>>>", cnfrMdlStored.Time_Sending)
	if cnfrMdlRecevied.Code != cnfrMdlStored.Code {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Invalid code"})
		return
	}
	diff := cnfrMdlRecevied.Time_Sending.Sub(cnfrMdlStored.Time_Sending).Minutes()
	if diff > 5 {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Code expired"})
		return
	}
	log.Println("DIFFERNCE BETWEEN TOW DATE ", cnfrMdlStored)
	// TODO: USER  CONFIRMED CAN CREATE ACCOUNT NOW  DB SECTION
	// if confirmModel.Time_Sending != codeStore[clientIP].Time_Sending {
	// 	c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Invalid code"})
	// 	return
	// }
}

// HANDLE WITH SIGNUP REQUEST
func (ic *AccountController) SignUpRequest(c *gin.Context) {
	log.Printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>  RECEVING SIGNUP REQUEST %s: ", c.ClientIP())
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
	codeStore[clientIP] = domain.ConfirmationModel{Code: code, IP: clientIP, Time_Sending: time.Now()}
	mu.Unlock()
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "we send six-degit to your email check to confirm you account",
		Data:    signupModel,
	})
}

// HANDLE WITH LOGIN ACCOUNT REQUEST
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
