package database

import (
	"database/sql"

	"educesol.com/payment-service/config"
	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
)

var Db *sql.DB
var err error

func Initialize() *sql.DB {
	conf := config.NewSecurityConfig()
	db_url := conf.DatabaseUrl
	Db, err = sql.Open("postgres", db_url)
	if err != nil {
		panic(err)
	}
	Db.SetMaxIdleConns(20)
	Db.SetMaxIdleConns(10)
	err = runMigrations()
	if err != nil {
		panic(err)
	}
	return Db
}
func runMigrations() error {
	driver, err := postgres.WithInstance(Db, &postgres.Config{})
	if err != nil {
		return err
	}
	m, err := migrate.NewWithDatabaseInstance(
		"file:///migrations", "postgres", driver,
	)
	if err != nil {
		return err
	}
	err = m.Up()
	if err != nil {
		return err
	}
	return nil
}
