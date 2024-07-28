package middleware

import (
	"back-end/api/controller/model"
	"back-end/util"
	"log"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func accessDenied(c *gin.Context, err string) {
	log.Print(err)
	c.JSON(http.StatusUnauthorized, model.ErrorResponse{Message: err})
	c.Abort()
}

func JwtAuthMiddleware(secret string, action string) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.Request.Header.Get("Authorization")
		t := strings.Split(authHeader, " ")
		if len(t) == 2 {
			authToken := t[1]
			authorized, err := util.IsAuthorized(authToken, secret)
			if authorized {
				userID, err := util.ExtractFieldFromToken(authToken, secret, "id")
				userAction, err1 := util.ExtractFieldFromToken(authToken, secret, "action")
				//log.Print(userAction + " " + action)
				if err != nil {
					c.JSON(http.StatusUnauthorized, model.ErrorResponse{Message: err.Error()})
					c.Abort()
					return
				}
				if err1 != nil {
					c.JSON(http.StatusUnauthorized, model.ErrorResponse{Message: err1.Error()})
					c.Abort()
					return
				}
				if action != userAction {
					c.JSON(http.StatusUnauthorized, model.ErrorResponse{Message: "Not authorized"})
					c.Abort()
					return
				}
				c.Set("x-user-id", userID)
				c.Set("x-user-token", authToken)
				c.Set("x-user-action", userAction)
				if userAction == action {
					c.Next()
					return
				}
				accessDenied(c, "You are not allowed to access this")
			}
			accessDenied(c, err.Error())
		}
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "Not valide token"})
		c.Abort()
	}
}
