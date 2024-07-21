package test

import (
	// "back-end/internal/domain"

	"context"
	"fmt"
	"testing"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
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
		serverAPI := options.ServerAPI(options.ServerAPIVersion1)
		opts := options.Client().ApplyURI("mongodb+srv://root:root@db.wkzekin.mongodb.net/?retryWrites=true&w=majority&appName=db").SetServerAPIOptions(serverAPI)
		// Create a new client and connect to the server
		client, err := mongo.Connect(context.TODO(), opts)
		if err != nil {
			panic(err)
		}
		defer func() {
			if err = client.Disconnect(context.TODO()); err != nil {
				panic(err)
			}
		}()
		// Send a ping to confirm a successful connection
		if err := client.Database("admin").RunCommand(context.TODO(), bson.D{{"ping", 1}}).Err(); err != nil {
			panic(err)
		}
		fmt.Println("Pinged your deployment. You successfully connected to MongoDB!")
	})
}
