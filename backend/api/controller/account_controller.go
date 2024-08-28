package controller

import (
	"back-end/api/controller/model"
	"back-end/cache"
	"back-end/core"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	"back-end/util/email"
	"back-end/util/email/html"
	util "back-end/util/token"
	"log"
	"net/http"
	"strings"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	redis "github.com/go-redis/redis/v8"
)

type AccountController struct {
	UserUsecase   usecase.UserUsecase
	WalletUseCase usecase.WalletUseCase
	Reason        string
	Rdb           *redis.Client
}

var codeStore = make(map[string]domain.ConfirmationModel)
var mu sync.Mutex

func sendOTP(signupModel domain.SignupModel, c *gin.Context, header string) {
	code, err := email.GenerateDigit()
	if err != nil {
		log.Panicf(err.Error())
		c.JSON(500, model.ErrorResponse{Message: err.Error()})
		return
	}
	//SEND EMAIL TO USER WITH CODE
	var htmlMsg html.HtlmlMsg
	htmlMsg.Code = code
	htmlMsg.FirstName = signupModel.FirstName
	htmlMsg.LastName = signupModel.LastName
	body := html.HtmlMessageConfirmAccount(htmlMsg)
	err = email.SendEmail(signupModel.Email, header, body)
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

// HANDLE WITH CONFIRAMTION ACCOUNT REQUEST
func (ac *AccountController) ConfirmeAccountRequest(c *gin.Context) {
	log.Println("_____________________________________RECEVING CONFIRAMTION REQUEST_____________________________________")
	var cnfrMdlRecevied domain.ConfirmationModel
	var Response model.Response
	var user domain.User
	token := ""
	Message := ""
	if !core.IsDataRequestSupported(&cnfrMdlRecevied, c) {
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
		if ok, err := ac.UserUsecase.IsAlreadyExist(c, &cnfrMdlStored.SgnModel); ok {
			c.JSON(500, model.ErrorResponse{Message: err.Error()})
			return
		}
		log.Println("CONFIRM ACCOUNT FOR SINGUP REASON")
		userParams := &usecase.UserParams{}
		userParams.Data = cnfrMdlStored.SgnModel
		resulatU := ac.UserUsecase.SignUp(c, userParams)
		println(resulatU)
		if resulatU.Err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: resulatU.Err.Error()})
			return
		}
		walletParams := &usecase.WalletParams{}
		walletParams.Data = resulatU.Data
		resulatW := ac.WalletUseCase.InitMyWallet(c, walletParams)
		if resulatW.Err != nil {
			log.Println(resulatW.Err)
			return
		}
		user = *resulatU.Data
		Message = "SIGNUP USER SUCCESSFULY"
		Response.UserData = resulatU
	case "reset-pwd":
		log.Println("CONFIRM ACCOUNT FOR RESET NEW PASSWORD REASON")
		user.ID = cnfrMdlStored.SgnModel.Id
		Message = "RESET PASSWORD TOKEN PREPARED SUCCESSFULY"
	}
	token, _ = util.CreateAccessToken(user.ID, core.RootServer.SECRET_KEY, 2, "User")
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
	if !core.IsDataRequestSupported(&signupModel, c) {
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
	log.Println("RECIEVE LOGIN REQUEST")
	var loginParms domain.LoginModel
	if !core.IsDataRequestSupported(&loginParms, c) {
		return
	}
	userParams := &usecase.UserParams{}
	userParams.Data = loginParms
	resulat := ic.UserUsecase.Login(c, userParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Incorrect credentials",
		})
		return
	}
	secret := core.RootServer.SECRET_KEY
	token, err := util.CreateAccessToken(resulat.Data.ID, secret, 2, resulat.Data.Role)
	if err != nil {
		c.JSON(500, model.ErrorResponse{Message: err.Error()})
		return
	}
	log.Printf("TOKEN %s", token)
	resulat.Data.ID = ""
	resulat.Data.PassWord = ""
	var Response model.Response
	Response.Token = token
	Response.UserData = resulat
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "LOGIN USERT SUCCESSFULY",
		Data:    Response,
	})

}

// HANDLE WITH LOGIN ACCOUNT REQUEST
func (ic *AccountController) LogoutRequest(c *gin.Context) {
	log.Println("LOGOUT REQUEST")
	authHeader := c.Request.Header.Get("Authorization")
	log.Println(authHeader)
	t := strings.Split(authHeader, " ")
	token := t[1]
	// Check if the token is empty
	if token == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Authorization header is missing"})
		return
	}
	expiration, _ := util.ExtractFieldFromToken(token, core.RootServer.SECRET_KEY, "exp")
	timestamp := int64(expiration.(float64))
	f := time.Unix(timestamp, 0)
	now := time.Now()
	duration := f.Sub(now)
	seconds := duration.Seconds()
	exp := time.Duration(seconds) * time.Second
	cache.AddKey(ic.Rdb, token, token, exp)
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "LOGOUT USER SUCCESSFULY",
		Data:    "",
	})

}

func (ic *AccountController) SetNewPwdRequest(c *gin.Context) {
	log.Println("REST PWD POST REQUEST")
	var RestPwdParms domain.SetNewPasswordModel
	if !core.IsDataRequestSupported(&RestPwdParms, c) {
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
	id, _ := util.ExtractFieldFromToken(token[1], core.RootServer.SECRET_KEY, "id")
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
	body := html.HtmlMessageRestPwd(user)
	err = email.SendEmail(data.Email, "Rest New Password", body)
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
	if !core.IsDataRequestSupported(&UserUpdated, c) {
		return
	}
	log.Println(UserUpdated)
	userParams := &usecase.UserParams{}
	userParams.Data = UserUpdated
	resulat := ic.UserUsecase.UpdateProfile(c, userParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Failed to Update Profile",
		})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "REST PWD REQUEST DONE SUCCESSFULY",
		Data:    resulat,
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
