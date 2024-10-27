package test

import (
	"back-end/core"
	util "back-end/util/token"
	"fmt"
	"log"
	"testing"
)

func TestToken(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		token, _ := util.CreateAccessToken("66c4f115033a5509879b67e9", core.RootServer.SECRET_KEY, 5000, "Admin")
		fmt.Println(token)
	})
}

func TestGetIdToken(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		token := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2Y2VkOTFiMDE1Y2VkNmVjZTkzNWVkNCIsImFjdGlvbiI6IlVzZXIiLCJleHAiOjE3Mjk5OTA0ODZ9.AX-ealIjnmKPNoTbgAojASsI4kuMEAMgIkPgaDfyo2I"
		id, err := util.ExtractFieldFromToken(token, core.RootServer.SECRET_KEY, "id")
		if err != nil {
			log.Printf("Failed to extract id from token: %v", err)
		}
		log.Println(id.(string))
	})
}
