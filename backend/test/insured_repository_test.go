package test

// import (
// 	"back-end/internal/domain"
// 	"back-end/internal/repository"
// 	"back-end/pkg/database/oracle"
// 	"context"
// 	"fmt"
// 	"log"
// 	"testing"

// 	"github.com/stretchr/testify/assert"
// )

// func TestCreate(t *testing.T) {
// 	t.Run("success", func(t *testing.T) {
// 		db, err1 := oracle.Connect()
// 		if err1 != nil {
// 			t.Fatal("Failed to connect to database: ", err1.Error())
// 		}
// 		fmt.Println("test Connecting to database")
// 		repo := repository.NewCommonRepository[domain.User](db)
// 		ctx := context.Background()
// 		err := repo.Save(ctx, domain.User{
// 			ID:       1,
// 			UserName: "Med",
// 			LastName: "NASSIME",
// 			Function: "11",
// 		}, "UserAgent")
// 		log.Println(err)
// 		assert.NoError(t, err)
// 	})
// }
