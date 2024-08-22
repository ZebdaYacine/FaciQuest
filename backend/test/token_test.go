package test

import (
	"back-end/core"
	util "back-end/util/token"
	"fmt"
	"testing"
)

func TestToken(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		token, _ := util.CreateAccessToken("66c4f115033a5509879b67e9", core.RootServer.SECRET_KEY, 5000, "Admin")
		fmt.Println(token)
	})
}
