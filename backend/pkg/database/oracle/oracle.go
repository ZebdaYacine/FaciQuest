package oracle

import (
	"back-end/pkg"
	"database/sql"
	"fmt"
	"log"

	_ "github.com/godror/godror"
)

func Connect() (*sql.DB, error) {
	var (
		username      = pkg.GetServerSetting().USER_DB
		password      = pkg.GetServerSetting().PASSWORD_DB
		connectString = pkg.GetServerSetting().SERVER_ADDRESS_DB
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
