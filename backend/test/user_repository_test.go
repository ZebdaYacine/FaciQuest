package test

import (
	"back-end/pkg/database"
	"context"
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

func TestUserRepository(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db := database.ConnectionDb()
		db.Collection("users")
		ctx := context.Background()
		collection := db.Collection("users")
		var resulat bson.M
		filter := bson.D{{Key: "email", Value: "zeddbdaadam1996@gmail.com"}}
		err := collection.FindOne(ctx, filter).Decode(&resulat)
		if err != mongo.ErrNoDocuments {
			fmt.Print("user already exist")
		}
		assert.NoError(t, err)
	})
}
