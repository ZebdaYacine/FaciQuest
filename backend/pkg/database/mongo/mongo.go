package mongo

import (
	"context"
	"fmt"
	"log"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func ConnectMongo() (*mongo.Client, error) {
	// Set MongoDB client options
	clientOptions := options.Client().ApplyURI("mongodb://localhost:27017")

	// Connect to MongoDB
	client, err := mongo.Connect(context.TODO(), clientOptions)
	if err != nil {
		log.Fatal(err)
	}

	// Check the connection
	err = client.Ping(context.TODO(), nil)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	fmt.Println("Connected to MongoDB!")
	return client, nil
}
func CreateUser(db *mongo.Client) error {
	// // Choose database and collection
	collection := db.Database("FaciQuest").Collection("users")

	// Insert a document
	user := bson.D{
		{Key: "username", Value: "ZedYacine"},
		{Key: "email", Value: "zebdaadam1996@gmail.com"},
		{Key: "password", Value: ""},
	}

	insertResult, err := collection.InsertOne(context.TODO(), user)
	if err != nil {
		log.Fatal(err)
		return err
	}
	fmt.Println("Inserted a single document: ", insertResult.InsertedID)
	return nil
}
