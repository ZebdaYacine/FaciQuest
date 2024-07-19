package test

import (
	"back-end/pkg/database"
	"context"
	"encoding/json"
	"log"
	"testing"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func TestMongoDBConnection(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		// ctx := context.Background()
		// db := database.ConnectionDb()
		// collection := db.Collection("users")
		// filtter := bson.D{
		// 	{Key: "username", Value: "zed yacine"},
		// 	{Key: "email", Value: "zebdaadam1996@gmail.com"},
		// }
		// var resulat bson.M

		// err := collection.FindOne(ctx, filtter).Decode(&resulat)
		// if err != nil {
		// 	log.Fatal(err)
		// }
		// id := resulat["_id"].(primitive.ObjectID).Hex()
		// fmt.Println("Found document with _id:", id)

		//assert.NoError(t, err1)
	})

	t.Run("success", func(t *testing.T) {
		c := context.Background()
		db := database.ConnectionDb()
		collection := db.Collection("users")
		id, err := primitive.ObjectIDFromHex("66977cee4f013719f6c0f437")
		if err != nil {
			log.Fatal(err)
		}
		var result bson.M
		err1 := collection.FindOne(c, bson.M{"_id": id}).Decode(&result)
		if err1 != nil {
			log.Fatalf("Failed to inset to UserAgent: %v", err)
		}
		jsonBytes, err := json.Marshal(result["role_id"])
		if err != nil {
			log.Println(err)
		}
		log.Println(string(jsonBytes))
		//assert.NoError(t, err1)
	})
}
