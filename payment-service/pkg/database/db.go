package database

import (
	"database/sql"

	"educesol.com/payment-service/config"
	_ "github.com/go-sql-driver/mysql"
)

var Db *sql.DB
var err error

func Initialize() *sql.DB {
	conf := config.NewSecurityConfig()
	db_url := conf.DatabaseUrl
	Db, err = sql.Open("mysql", db_url)
	if err != nil {
		panic(err)
	}
	Db.SetMaxIdleConns(20)
	Db.SetMaxIdleConns(10)
	createTables()
	return Db
}
func createTables() {
	AccountTableQuery := `
	CREATE TABLE IF NOT EXISTS accounts(
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	userId VARCHAR(255) UNIQUE NOT NULL,
	contractCode VARCHAR(255) NOT NULL,
    accountReference VARCHAR(255) NOT NULL,
	accountNumber VARCHAR(255) NOT NULL,
	accountName TEXT NOT NULL,
	bankName VARCHAR(255) NOT NULL,
	bankCode INTEGER NOT NULL,
	currencyCode VARCHAR(255) NOT NULL,
	customerName TEXT NOT NULL,
	customerEmail TEXT NOT NULL,
	accountBalance DECIMAL(10,4) NOT NULL DEFAULT 0.00,
	createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	)
	`
	_, err = Db.Exec(AccountTableQuery)
	if err != nil {
		panic(err)
	}
}
