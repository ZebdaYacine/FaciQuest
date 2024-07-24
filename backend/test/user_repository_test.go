package test

import (
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"
	"testing"

	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/bson"
)

func TestUserRepository(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db := database.ConnectionDb()
		db.Collection("users")
		ctx := context.Background()
		collection := db.Collection("users")
		filterUpdate := bson.D{{Key: "email", Value: "medYaine996@gmail.com"}}
		update := bson.M{
			"$set": bson.M{"password": "medFed"},
		}
		r, err := collection.UpdateOne(ctx, filterUpdate, update)
		if err != nil {
			log.Fatal(err)
		}
		var updatedDocument bson.M
		err = collection.FindOne(ctx, filterUpdate).Decode(&updatedDocument)
		if err != nil {
			log.Fatal("Error finding updated document:", err)
		}
		fmt.Print("updatedDocument", updatedDocument)
		fmt.Printf("Matched %v documents and updated %v documents.\n", r, r.ModifiedCount)
		assert.NoError(t, err)
	})
}
