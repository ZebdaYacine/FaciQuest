package oracle

import (
	"back-end/pkg"
	"database/sql"
	"fmt"
	"log"

	_ "github.com/godror/godror"
)

func Connect() (*sql.DB, error) {
	var SETTING = pkg.GET_DB_SERVER_SEETING()
	var (
		username      = SETTING.USER_DB
		password      = SETTING.PASSWORD_DB
		connectString = SETTING.SERVER_ADDRESS_DB
	)
	// Create data source name (DSN)
	dsn := fmt.Sprintf("%s/%s@%s", username, password, connectString)
	// Open a database connection
	db, err := sql.Open("godror", dsn)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	message := fmt.Sprintf("Connected to %s database successfully", username)
	log.Println(message)
	return db, nil
}
