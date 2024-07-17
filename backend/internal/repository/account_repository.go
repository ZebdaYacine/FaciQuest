package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
)

type accountRepository[K domain.Auth] struct {
	database *database.Database
}

func NewAccountRepository[K domain.Auth](db *database.Database) domain.AccountRepository[K] {
	return &accountRepository[K]{
		database: db,
	}
}
