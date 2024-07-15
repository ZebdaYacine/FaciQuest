package repository

import (
	"back-end/internal/domain"
	"back-end/internal/repository/crud"
	"back-end/util"
	"context"
	"database/sql"
	"log"
)

type commonRepository[T domain.Person] struct {
	database *sql.DB
}

func NewCommonRepository[T domain.Person](db *sql.DB) domain.CommonRepository[T] {
	return &commonRepository[T]{
		database: db,
	}
}

func (ur *commonRepository[T]) CreateInsured(c context.Context, object domain.Insured) error {
	log.Println("CreateUser repository launched successfully")
	db, err := util.PingDb(ur.database)
	if err != nil {
		return err
	}
	insured, _ := any(object).(domain.Insured)
	_, err = crud.Insert_Insured(db, insured)
	if err != nil {
		log.Println("Error creating Insured: ", err.Error())
		return err
	}
	return nil
}

func (ur *commonRepository[T]) UpdateInsured(c context.Context, object domain.Insured) error {
	log.Println("UPDATE USER repository launched successfully")
	db, err := util.PingDb(ur.database)
	if err != nil {
		return err
	}
	insured, _ := any(object).(domain.Insured)
	_, err = crud.Insert_Insured(db, insured)
	if err != nil {
		log.Println("Error creating Insured: ", err.Error())
		return err
	}
	return nil
}
