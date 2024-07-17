package test

import (
	"back-end/internal/domain"
	"back-end/pkg"
	"back-end/pkg/database/mongo"
	"context"
	"log"
	"testing"
	"time"

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
		var db_opt = pkg.GET_DB_SERVER_SEETING()
		client, err := mongo.NewClient(db_opt.SERVER_ADDRESS_DB)
		if err != nil {
			log.Fatalf("Failed to create MongoDB client: %v", err)
		}
		// Create a context with a timeout
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		// Connect to the MongoDB server
		if err := client.Connect(ctx); err != nil {
			log.Fatalf("Failed to connect to MongoDB: %v", err)
		}
		// Get the database and collection
		db := client.Database(db_opt.DB_NAME)
		collection := db.Collection("users")
		// Define the document to insert

		var userAgent = domain.UserAgent{
			Id:       1,
			UserName: "johndoe",
			Password: "password123",
			Role_ID:  1,
		}
		userID, err1 := collection.InsertOne(ctx, userAgent)
		if err1 != nil {
			log.Fatalf("Failed to inset to UserAgent: %v", err)
		}
		log.Printf("Create user agent with id %d", userID)
		assert.NoError(t, err)
	})
}
