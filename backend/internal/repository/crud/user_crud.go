package crud

import (
	"back-end/internal/domain"
	"back-end/pkg/database/oracle"
	"database/sql"
)

func Get_Role_Query(db *sql.DB, ID_USER int64) (*sql.Rows, error) {
	return db.Query(
		oracle.GET_ROLE_SQL,
		ID_USER,
	)
}

func Insert_Insured(db *sql.DB, insured domain.Insured) (sql.Result, error) {
	return db.Exec(
		oracle.Insert_Insured,
		insured.FirstName,
	)
}
