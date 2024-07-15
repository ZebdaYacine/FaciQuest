package repository

import (
	"back-end/internal/domain"
	"back-end/internal/repository/crud"
	"back-end/util"
	"context"
	"database/sql"
	"fmt"
	"log"
)

type accountRepository[K domain.Auth] struct {
	database *sql.DB
}

func NewAccountRepository[K domain.Auth](db *sql.DB) domain.AccountRepository[K] {
	return &accountRepository[K]{
		database: db,
	}
}

// GetRole implements domain.AccountRepository.
func (ar *accountRepository[K]) GetRole(c context.Context, id int64) (int64, error) {
	log.Println("GetRole User repository launched successfully")
	db, err := util.PingDb(ar.database)
	if err != nil {
		return 0, err
	}
	row, err := crud.Get_Role_Query(db, id)
	if err != nil {
		log.Println("Error Select usert : ", err.Error())
		return id, err
	}
	row.Next()
	err = row.Scan(&id)
	if err != nil {
		fmt.Println("Error scanning row:", err.Error())
		return 0, err
	}
	return id, nil
}

// Login implements domain.AccountRepository.
func (ar *accountRepository[K]) Login(c context.Context, data domain.LoginModel) (int64, error) {
	log.Println("Login User repository launched successfully")
	db, err := util.PingDb(ar.database)
	var id int64 = 0
	if err != nil {
		return 0, err
	}
	loginModel, _ := any(data).(domain.LoginModel)
	row, err := crud.Login_Query(db, loginModel)
	if err != nil {
		log.Println("Error Select usert : ", err.Error())
		return id, err
	}
	row.Next()
	err = row.Scan(&id)
	if err != nil {
		fmt.Println("Error scanning row:", err.Error())
		return 0, err
	}
	return id, nil
}
