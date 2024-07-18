package test

import (
	"back-end/pkg/database/mongo"
	"context"
	"log"
	"testing"

	"github.com/stretchr/testify/assert"
)

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

func TestMongoDBConnection(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		ctx := context.Background()
		db := mongo.ConnectionDb()
		collection := db.Collection("users")

		userID, err1 := collection.InsertOne(ctx, struct{ id int }{10})
		if err1 != nil {
			log.Fatalf("Failed to inset to UserAgent: %v", err1)
		}
		log.Printf("Create user agent with id %v", userID)
		assert.NoError(t, err1)
	})
}
