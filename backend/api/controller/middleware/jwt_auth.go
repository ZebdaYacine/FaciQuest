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
	log.Println("JWT error:", err)
	c.JSON(http.StatusUnauthorized, model.ErrorResponse{Message: err})
	c.Abort()
}

func JwtAuthMiddleware(secret string, action string) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			accessDenied(c, "Authorization header missing")
			return
		}

		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") {
			accessDenied(c, "Authorization header format must be 'Bearer <token>'")
			return
		}

		authToken := parts[1]
		claims, err := util.ExtractClaims(authToken, secret)
		if err != nil {
			accessDenied(c, err.Error())
			return
		}

		if claims.Action != action {
			accessDenied(c, "You are not allowed to access this resource")
			return
		}

		// Save values for controllers
		c.Set("x-user-id", claims.ID)
		c.Set("x-user-token", authToken)
		c.Set("x-user-action", claims.Action)

		c.Next()
	}
}
