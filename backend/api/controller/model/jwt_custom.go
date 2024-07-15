package model

import (
	"github.com/golang-jwt/jwt/v4"
)

type JwtCustomClaims struct {
	ID     string `json:"id"`
	Action string `json:"action"`
	jwt.RegisteredClaims
}

// type JwtCustomRefreshClaims struct {
// 	ID string `json:"id"`
// 	jwt.RegisteredClaims
// }
