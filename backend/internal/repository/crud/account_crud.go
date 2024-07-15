package crud

import (
	"back-end/internal/domain"
	"back-end/pkg/database/oracle"
	"database/sql"
)

func Login_Query(db *sql.DB, user domain.LoginModel) (*sql.Rows, error) {
	return db.Query(
		oracle.Login_SQL,
		user.UserName,
		user.Password,
	)
}
