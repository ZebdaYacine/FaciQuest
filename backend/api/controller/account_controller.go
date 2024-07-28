package controller

import (
	"back-end/api/controller/model"
	"back-end/common"
	"back-end/internal/domain"
	"back-end/util"
	"log"
	"net/http"
	"strings"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

type AccountController struct {
	UserUsecase domain.UserUsecase
	Reason      string
}

var codeStore = make(map[string]domain.ConfirmationModel)
var mu sync.Mutex

func sendOTP(signupModel domain.SignupModel, c *gin.Context, header string) {
	code, err := util.GenerateDigit()
	if err != nil {
		log.Panicf(err.Error())
		c.JSON(500, model.ErrorResponse{Message: err.Error()})
		return
	}
	//SEND EMAIL TO USER WITH CODE
	var htmlMsg domain.HtlmlMsg
	htmlMsg.Code = code
	htmlMsg.FirstName = signupModel.FirstName
	htmlMsg.LastName = signupModel.LastName
	body := util.HtmlMessageConfirmAccount(htmlMsg)
	err = util.SendEmail(signupModel.Email, header, body)
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
	signupModel.Id = ""
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "we send six-degit to your email check to confirm you account",
		Data:    signupModel,
	})
}

func verifyOTP(cnfrMdlRecevied domain.ConfirmationModel, c *gin.Context) (bool, *domain.ConfirmationModel) {
	clientIP := c.ClientIP()
	mu.Lock()
	cnfrMdlStored, exists := codeStore[clientIP]
	mu.Unlock()
	if !exists {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "No code generated for this client"})
		return false, nil
	}
	if cnfrMdlRecevied.Code != cnfrMdlStored.Code {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Invalid code"})
		return false, nil
	}
	diff := cnfrMdlRecevied.Time_Sending.Sub(cnfrMdlStored.Time_Sending).Minutes()
	if diff > 5 {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Code expired"})
		return false, nil
	}
	return true, &cnfrMdlStored
}

func isDataRequestSupported[T domain.Account](data *T, c *gin.Context) bool {
	err := c.ShouldBindJSON(data)
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
	var Response model.Response
	var user domain.User
	token := ""
	Message := ""
	if !isDataRequestSupported(&cnfrMdlRecevied, c) {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "request body not supported "})
		return
	}
	log.Print(cnfrMdlRecevied)
	isCorrect, cnfrMdlStored := verifyOTP(cnfrMdlRecevied, c)
	if !isCorrect {
		return
	}
	switch cnfrMdlRecevied.Reason {
	case "sing-up":
		log.Println("CONFIRM ACCOUNT FOR SINGUP REASON")
		user, err := ac.UserUsecase.SignUp(c, &cnfrMdlStored.SgnModel)
		if err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: err.Error()})
			return
		}
		_, err1 := ac.UserUsecase.InitMyWallet(c, user)
		if err1 != nil {
			log.Println(err1.Error())
			return
		}
		Message = "SIGNUP USER SUCCESSFULY"
		Response.UserData = user
	case "reset-pwd":
		log.Println("CONFIRM ACCOUNT FOR RESET NEW PASSWORD REASON")
		user.ID = cnfrMdlStored.SgnModel.Id
		Message = "RESET PASSWORD TOKEN PREPARED SUCCESSFULY"
	}
	token, _ = util.CreateAccessToken(user.ID, common.RootServer.SECRET_KEY, 2, "User")
	user.ID = ""
	user.PassWord = ""
	log.Printf("TOKEN %s", token)
	Response.Token = token
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: Message,
		Data:    Response,
	})
}

// HANDLE WITH SIGNUP REQUEST
func (ic *AccountController) SignUpRequest(c *gin.Context) {
	var signupModel domain.SignupModel
	if !isDataRequestSupported(&signupModel, c) {
		return
	}
	log.Print(signupModel)
	if ok, err := ic.UserUsecase.IsAlreadyExist(c, &signupModel); ok {
		c.JSON(500, model.ErrorResponse{Message: err.Error()})
		return
	}
	sendOTP(signupModel, c, "Confirme Account")
}

// HANDLE WITH LOGIN ACCOUNT REQUEST
func (ic *AccountController) LoginRequest(c *gin.Context) {
	log.Println("LOGIN POST REQUEST")
	var loginParms domain.LoginModel
	if !isDataRequestSupported(&loginParms, c) {
		return
	}
	log.Println(loginParms)
	user, err := ic.UserUsecase.Login(c, &loginParms)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Incorrect credentials",
		})
		return
	}
	secret := common.RootServer.SECRET_KEY
	token, err := util.CreateAccessToken(user.ID, secret, 2, user.Role)
	if err != nil {
		c.JSON(500, model.ErrorResponse{Message: err.Error()})
		return
	}
	log.Printf("TOKEN %s", token)
	user.ID = ""
	user.PassWord = ""
	var Response model.Response
	Response.Token = token
	Response.UserData = user
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "LOGIN USERT SUCCESSFULY",
		Data:    Response,
	})

}

func (ic *AccountController) SetNewPwdRequest(c *gin.Context) {
	log.Println("REST PWD POST REQUEST")
	var RestPwdParms domain.SetNewPasswordModel
	if !isDataRequestSupported(&RestPwdParms, c) {
		return
	}
	log.Print(RestPwdParms)
	authHeader := c.Request.Header.Get("Authorization")
	log.Println(authHeader)
	token := strings.Split(authHeader, " ")
	// Check if the token is empty
	if token[1] == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Authorization header is missing"})
		return
	}
	id, _ := util.ExtractFieldFromToken(token[1], common.RootServer.SECRET_KEY, "id")
	log.Print(id)
	clientIP := c.ClientIP()
	mu.Lock()
	cnfrMdlStored, exists := codeStore[clientIP]
	mu.Unlock()
	if !exists {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "server can't handle you request in this moment"})
	}
	if cnfrMdlStored.SgnModel.Id != id {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Fake token"})
		return
	}
	var data = domain.User{}
	data.PassWord = RestPwdParms.NewPassword
	data.Email = cnfrMdlStored.SgnModel.Email
	user, err := ic.UserUsecase.SetNewPassword(c, &data)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Failed to Reset New Password",
		})
		return
	}
	body := util.HtmlMessageRestPwd(user)
	err = util.SendEmail(data.Email, "Rest New Password", body)
	if err != nil {
		log.Panicf(err.Error())
		c.JSON(500, model.ErrorResponse{Message: "Error while sending REST PWD Email"})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "REST PWD REQUEST DONE SUCCESSFULY",
		Data:    "",
	})

}

func (ic *AccountController) UpdateProfileRequest(c *gin.Context) {
	log.Println("UPDATE PROFILE POST REQUEST")
	var UserUpdated domain.User
	if !isDataRequestSupported(&UserUpdated, c) {
		return
	}
	log.Println(UserUpdated)
	user, err := ic.UserUsecase.UpdateProfile(c, &UserUpdated)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Failed to Update Profile",
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "REST PWD REQUEST DONE SUCCESSFULY",
		Data:    user,
	})
}

func (ic *AccountController) ForgetPwdRequest(c *gin.Context) {
	log.Println("FORGET PWD POST REQUEST")
	email := c.PostForm("email")
	var signupModel domain.SignupModel
	signupModel.Email = email
	user, err := ic.UserUsecase.GetUserByEmail(c, email)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "User not found"})
		return
	}
	signupModel.Id = user.ID
	sendOTP(signupModel, c, "set New Password")
}
