package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"encoding/json"
	"log"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func primitiveMToJSONString(doc primitive.M) (string, error) {
	jsonBytes, err := json.Marshal(doc)
	if err != nil {
		return "", err
	}
	return string(jsonBytes), nil
}

type accountRepository[K domain.Auth] struct {
	database database.Database
}

func NewAccountRepository[K domain.Auth](db database.Database) domain.AccountRepository[K] {
	return &accountRepository[K]{
		database: db,
	}
}

// SignUp implements domain.AccountRepository.
func (ar *accountRepository[K]) SignUp(c context.Context, data *domain.SignupModel) (string, error) {
	collection := ar.database.Collection("users")
	userID, err1 := collection.InsertOne(c, data)
	if err1 != nil {
		log.Fatalf("Failed to inset to UserAgent: %v", err1)
	}
	log.Printf("Create user agent with id %v", userID)
	return userID.(string), nil
}

// Login implements domain.AccountRepository.
func (ar *accountRepository[K]) Login(c context.Context, data *domain.LoginModel) (string, error) {
	collection := ar.database.Collection("users")
	var resulat bson.M
	err := collection.FindOne(c, data).Decode(&resulat)
	if err != nil {
		log.Fatal(err)
	}
	id := resulat["_id"].(primitive.ObjectID).Hex()
	return id, nil
}

// GetRole implements domain.AccountRepository.
func (ar *accountRepository[K]) GetRole(c context.Context, userId string) (string, error) {
	collection := ar.database.Collection("users")
	id, err := primitive.ObjectIDFromHex(userId)
	if err != nil {
		log.Fatal(err)
	}
	var result bson.M
	err1 := collection.FindOne(c, bson.M{"_id": id}).Decode(&result)
	if err1 != nil {
		log.Fatalf("Failed to find to user: %v", err)
	}
	jsonBytes, err := json.Marshal(result["role_id"])
	if err != nil {
		log.Println(err)
	}
	return string(jsonBytes), nil
}
