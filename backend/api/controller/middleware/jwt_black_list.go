package middleware

import (
	"back-end/cache"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	redis "github.com/go-redis/redis/v8"
)

func JwtBlackListMiddleware(redis *redis.Client) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.Request.Header.Get("Authorization")
		t := strings.Split(authHeader, " ")
		if len(t) == 2 {
			token := t[1]
			val, err := cache.GetKey(redis, token)
			if err != nil {
				accessDenied(c, err.Error())
				return
			}
			if val != "" {
				c.JSON(http.StatusUnauthorized, "This token is in the black list")
				c.Abort()
				return
			}
			c.Next()
			return
		}
	}
}
