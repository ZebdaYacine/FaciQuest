package test

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"back-end/pkg/database/oracle"
	"back-end/util"
	"context"
	"fmt"
	"log"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestCreate(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db, err1 := oracle.Connect()
		if err1 != nil {
			t.Fatal("Failed to connect to database: ", err1.Error())
		}
		fmt.Println("test Connecting to database")
		repo := repository.NewAccountRepository[domain.LoginModel](db)
		ctx := context.Background()
		id, err := repo.Login(ctx,
			domain.LoginModel{
				UserName: "zed",
				Email:    "",
				Password: "root",
			})
		log.Printf("ROLE ID %d, ", id)
		assert.NoError(t, err)
	})
	t.Run("success", func(t *testing.T) {
		db, err1 := oracle.Connect()
		if err1 != nil {
			t.Fatal("Failed to connect to database: ", err1.Error())
		}
		fmt.Println("test Connecting to database")
		repo := repository.NewAccountRepository[domain.LoginModel](db)
		ctx := context.Background()
		role, err := repo.GetRole(ctx, 1)
		log.Printf("ROLE ID %d, ", role)
		log.Printf("ROLE ID %s, ", util.GenerateRole(role))
		assert.NoError(t, err)
	})
}
