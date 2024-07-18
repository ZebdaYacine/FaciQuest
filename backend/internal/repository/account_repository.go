package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"log"
)

type accountRepository[K domain.Auth] struct {
	database database.Database
}

// SignUp implements domain.AccountRepository.
func (ar *accountRepository[K]) SignUp(c context.Context, data *domain.SignupModel) (interface{}, error) {
	collection := ar.database.Collection("users")
	userID, err1 := collection.InsertOne(c, data)
	if err1 != nil {
		log.Fatalf("Failed to inset to UserAgent: %v", err1)
	}
	log.Printf("Create user agent with id %v", userID)
	return userID, nil
}

func NewAccountRepository[K domain.Auth](db database.Database) domain.AccountRepository[K] {
	return &accountRepository[K]{
		database: db,
	}
}
