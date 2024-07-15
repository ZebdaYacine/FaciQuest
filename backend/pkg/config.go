package pkg

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)

func LoadEnv() {
	err := godotenv.Load("../.env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	godotenv.Load(".env")
}

type ServerSetting struct {
	SERVER_ADDRESS    string
	SERVER_PORT       string
	USER_DB           string
	PASSWORD_DB       string
	SERVER_ADDRESS_DB string
	SECRET_KEY        string
}

func GetServerSetting() ServerSetting {
	LoadEnv()
	return ServerSetting{
		SERVER_ADDRESS:    os.Getenv("SERVER_ADDRESS"),
		SERVER_PORT:       os.Getenv("SERVER_PORT"),
		USER_DB:           os.Getenv("USER_DB"),
		PASSWORD_DB:       os.Getenv("PASSWORD_DB"),
		SERVER_ADDRESS_DB: os.Getenv("SERVER_ADDRESS_DB"),
		SECRET_KEY:        os.Getenv("SECRET_KEY"),
	}
}

func GetUrl() string {
	LoadEnv()
	url := fmt.Sprintf("%s:%s", os.Getenv("SERVER_ADDRESS"), os.Getenv("SERVER_PORT"))
	return url
}
