package util

import (
	"database/sql"
	"fmt"
)

func PingDb(db *sql.DB) (*sql.DB, error) {
	if err := db.Ping(); err != nil {
		return nil, fmt.Errorf("failed to ping the DB: %w", err)
	}
	return db, nil
}
