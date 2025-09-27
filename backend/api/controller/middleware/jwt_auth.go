package middleware

import (
	"back-end/api/controller/model"
	util "back-end/util/token"
	"log"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func accessDenied(c *gin.Context, err string) {
	log.Println(err)
	c.JSON(http.StatusUnauthorized, model.ErrorResponse{Message: err})
	c.Abort()
}

func JwtAuthMiddleware(secret string, action string) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.Request.Header.Get("Authorization")
		t := strings.Split(authHeader, " ")
		if len(t) != 2 {
			accessDenied(c, "Not a valid token")
			return
		}

		authToken := t[1]
		claims, err := util.ExtractClaims(authToken, secret)
		if err != nil {
			accessDenied(c, err.Error())
			return
		}

		if claims.Action != action {
			accessDenied(c, "You are not allowed to access this")
			return
		}

		c.Set("x-user-id", claims.ID)
		c.Set("x-user-token", authToken)
		c.Set("x-user-action", claims.Action)
		c.Next()

	}
}
