package controller

import (
	"back-end/api/controller/model"
	"back-end/core"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	"back-end/util/email"
	"back-end/util/email/html"
	util "back-end/util/token"
	"fmt"
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

// --- Helper: Send OTP ---
func sendOTP(signupModel domain.SignupModel, c *gin.Context, header string) {
	code, err := email.GenerateDigit()
	if err != nil {
		log.Println("Error generating OTP:", err)
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "Failed to generate OTP"})
		return
	}

	// Prepare email body
	// var htmlMsg html.HtlmlMsg
	// htmlMsg.Code = code
	// htmlMsg.FirstName = signupModel.FirstName
	// htmlMsg.LastName = signupModel.LastName
	// body := html.HtmlMessageConfirmAccount(htmlMsg)
	token, err := util.CreateAccessToken(signupModel.Id, core.RootServer.SECRET_KEY, 15, "User")
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "Failed to create reset token"})
		return
	}
	body := fmt.Sprintf(`
		<h2>Password Reset Request</h2>
		<p>Here is your reset token:</p>
		<p>And your verification PIN:</p>
		<p><b>%s</b></p>
		<p>Click 
		<a href="http://localhost:5173/?token=%s&pin=%s">here</a> to reset your password.</p>
	    `, code, token, code)

	// Send email
	if err := email.SendEmail(signupModel.Email, header, body); err != nil {
		log.Println("Error sending OTP email:", err)
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "Can't send confirmation code"})
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

	log.Printf("OTP sent to %s stored for IP %s", signupModel.Email, clientIP)

	signupModel.Id = "" // avoid leaking ID back to client
	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "We sent a 6-digit code to your email. Please confirm your account.",
		Data:    signupModel,
	})
}

// --- Helper: Verify OTP ---
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
	// ✅ Corrected: use current time for expiration check
	if time.Since(cnfrMdlStored.Time_Sending) > 5*time.Minute {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Code expired"})
		return false, nil
	}
	return true, &cnfrMdlStored
}

// --- Confirm Account ---
func (ac *AccountController) ConfirmeAccountRequest(c *gin.Context) {
	log.Println("=== Receiving Confirmation Request ===")

	var cnfrMdlRecevied domain.ConfirmationModel
	if !core.IsDataRequestSupported(&cnfrMdlRecevied, c) {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Invalid request body"})
		return
	}

	isCorrect, cnfrMdlStored := verifyOTP(cnfrMdlRecevied, c)
	if !isCorrect {
		return
	}

	var Response model.Response
	var user domain.User
	var Message string

	switch cnfrMdlRecevied.Reason {
	case "sing-up":
		if ok, err := ac.UserUsecase.IsAlreadyExist(c, &cnfrMdlStored.SgnModel); ok {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: err.Error()})
			return
		}
		log.Println("Confirm account for SIGNUP reason")

		// Sign up user
		userParams := &usecase.UserParams{Data: cnfrMdlStored.SgnModel}
		resulatU := ac.UserUsecase.SignUp(c, userParams)
		if resulatU.Err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: resulatU.Err.Error()})
			return
		}

		// Init wallet
		walletParams := &usecase.WalletParams{Data: resulatU.Data}
		resulatW := ac.WalletUseCase.InitMyWallet(c, walletParams)
		if resulatW.Err != nil {
			log.Println("Error creating wallet:", resulatW.Err)
			// don’t return, user still created
		}

		user = *resulatU.Data
		Message = "Signup successful"
		Response.UserData = resulatU

	case "reset-pwd":
		log.Println("Confirm account for RESET PASSWORD reason")
		user.ID = cnfrMdlStored.SgnModel.Id
		Message = "Reset password token prepared successfully"
	default:
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Unknown confirmation reason"})
		return
	}

	// Generate token
	token, _ := util.CreateAccessToken(user.ID, core.RootServer.SECRET_KEY, 2, "User")
	user.ID = ""
	user.PassWord = ""
	Response.Token = token

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: Message,
		Data:    Response,
	})
}

// --- Signup ---
func (ic *AccountController) SignUpRequest(c *gin.Context) {
	var signupModel domain.SignupModel
	if !core.IsDataRequestSupported(&signupModel, c) {
		return
	}
	if ok, err := ic.UserUsecase.IsAlreadyExist(c, &signupModel); ok {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: err.Error()})
		return
	}
	sendOTP(signupModel, c, "Confirm Account")
}

// --- Login ---
func (ic *AccountController) LoginRequest(c *gin.Context) {
	log.Println("=== Receive Login Request ===")

	var loginParms domain.LoginModel
	if !core.IsDataRequestSupported(&loginParms, c) {
		return
	}

	userParams := &usecase.UserParams{Data: loginParms}
	resulat := ic.UserUsecase.Login(c, userParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Incorrect credentials"})
		return
	}

	secret := core.RootServer.SECRET_KEY
	token, err := util.CreateAccessToken(resulat.Data.ID, secret, 2, resulat.Data.Role)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: err.Error()})
		return
	}

	resulat.Data.ID = ""
	resulat.Data.PassWord = ""

	var Response model.Response
	Response.Token = token
	Response.UserData = resulat

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "Login successful",
		Data:    Response,
	})
}

// --- Logout ---
func (ic *AccountController) LogoutRequest(c *gin.Context) {
	log.Println("=== Logout Request ===")

	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Authorization header is required",
		})
		return
	}

	parts := strings.SplitN(authHeader, " ", 2)
	if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Authorization header must be in format: Bearer <token>",
		})
		return
	}

	token := parts[1]

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "Logout successful",
		Data:    token,
	})
}

// func (ic *AccountController) SetNewPwdRequest(c *gin.Context) {
// 	log.Println("=== Reset Password Request ===")

// 	var RestPwdParms domain.SetNewPasswordModel
// 	if !core.IsDataRequestSupported(&RestPwdParms, c) {
// 		return
// 	}

// 	log.Println(RestPwdParms)
// 	userId := core.GetIdUser(c)
// 	user, _ := ic.UserUsecase.GetUserById(c, userId)
// 	var data = domain.User{
// 		Email:    user.Email,
// 		PassWord: RestPwdParms.NewPassword,
// 	}
// 	user, err := ic.UserUsecase.SetNewPassword(c, &data)
// 	if err != nil {
// 		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Failed to reset password"})
// 		return
// 	}

// 	body := html.HtmlMessageRestPwd(user)
// 	if err := email.SendEmail(data.Email, "Password Reset Successful", body); err != nil {
// 		log.Println("Failed to send reset confirmation email:", err)
// 		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "Password updated but email failed"})
// 		return
// 	}

// 	c.JSON(http.StatusOK, model.SuccessResponse{
// 		Message: "Password reset successful",
// 		Data:    "",
// 	})
// }

func (ic *AccountController) SetNewPwdRequest(c *gin.Context) {
	log.Println("=== Reset Password Request ===")

	var RestPwdParms domain.SetNewPasswordWebModel
	if !core.IsDataRequestSupported(&RestPwdParms, c) {
		return
	}

	authHeader := c.Request.Header.Get("Authorization")
	tokens := strings.Split(authHeader, " ")
	if len(tokens) < 2 {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Authorization header missing or invalid"})
		return
	}
	token := tokens[1]

	claims, err := util.ExtractClaims(token, core.RootServer.SECRET_KEY)
	if err != nil {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{Message: err.Error()})
		return
	}

	byPin := core.GetIdUser(c) == ""
	data := domain.User{}
	if byPin {
		log.Println("Resetting password via PIN")
		id := claims.ID
		clientIP := c.ClientIP()
		mu.Lock()
		cnfrMdlStored, exists := codeStore[clientIP]
		mu.Unlock()

		if !exists {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "No active reset request for this client"})
			return
		}

		if cnfrMdlStored.SgnModel.Id != id {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Token does not match user"})
			return
		}

		data = domain.User{
			Email:    cnfrMdlStored.SgnModel.Email,
			PassWord: RestPwdParms.NewPassword,
		}
	} else {
		log.Println("Resetting password via authenticated user")
		userId := core.GetIdUser(c)
		user, err := ic.UserUsecase.GetUserById(c, userId)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "User not found"})
			return
		}
		data = domain.User{
			Email:    user.Email,
			PassWord: RestPwdParms.NewPassword,
		}
	}

	user, err := ic.UserUsecase.SetNewPassword(c, &data)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Failed to reset password"})
		return
	}

	body := html.HtmlMessageRestPwd(user)
	if err := email.SendEmail(data.Email, "Password Reset Successful", body); err != nil {
		log.Println("Failed to send reset confirmation email:", err)
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "Password updated but email failed"})
		return
	}

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "Password reset successful",
		Data:    "",
	})
}

// --- Reset Password (Set New) ---
func (ic *AccountController) SetNewPwdRequestWeb(c *gin.Context) {
	log.Println("=== Reset Password Request ===")

	var RestPwdParms domain.SetNewPasswordWebModel
	if !core.IsDataRequestSupported(&RestPwdParms, c) {
		return
	}

	authHeader := c.Request.Header.Get("Authorization")
	tokens := strings.Split(authHeader, " ")
	if len(tokens) < 2 {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Authorization header missing or invalid"})
		return
	}
	token := tokens[1]
	claims, err := util.ExtractClaims(token, core.RootServer.SECRET_KEY)
	if err != nil {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{Message: err.Error()})
		return
	}
	id := claims.ID
	clientIP := c.ClientIP()
	mu.Lock()
	cnfrMdlStored, exists := codeStore[clientIP]
	mu.Unlock()

	if !exists {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "No active reset request for this client"})
		return
	}
	if cnfrMdlStored.SgnModel.Id != id {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Token does not match user"})
		return
	}

	log.Println(RestPwdParms)

	if cnfrMdlStored.Code != RestPwdParms.Pin {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Invalid PIN"})
		return
	}

	var data = domain.User{
		Email:    cnfrMdlStored.SgnModel.Email,
		PassWord: RestPwdParms.NewPassword,
	}
	user, err := ic.UserUsecase.SetNewPassword(c, &data)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Failed to reset password"})
		return
	}

	body := html.HtmlMessageRestPwd(user)
	if err := email.SendEmail(data.Email, "Password Reset Successful", body); err != nil {
		log.Println("Failed to send reset confirmation email:", err)
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "Password updated but email failed"})
		return
	}

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "Password reset successful",
		Data:    "",
	})
}

// --- Update Profile ---
func (ic *AccountController) UpdateProfileRequest(c *gin.Context) {
	log.Println("=== Update Profile Request ===")

	var UserUpdated domain.User
	if !core.IsDataRequestSupported(&UserUpdated, c) {
		return
	}

	userParams := &usecase.UserParams{Data: UserUpdated}
	resulat := ic.UserUsecase.UpdateProfile(c, userParams)
	if resulat.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Failed to update profile"})
		return
	}

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "Profile updated successfully",
		Data:    resulat,
	})
}

// --- Forget Password ---
func (ic *AccountController) ForgetPwdRequest(c *gin.Context) {
	log.Println("=== Forget Password Request ===")

	emailAddr := c.PostForm("email")
	if emailAddr == "" {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "Email is required"})
		return
	}

	user, err := ic.UserUsecase.GetUserByEmail(c, emailAddr)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "User not found"})
		return
	}

	var signupModel domain.SignupModel
	signupModel.Email = emailAddr
	signupModel.Id = user.ID

	sendOTP(signupModel, c, "Reset Password")
}
