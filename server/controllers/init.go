package controllers

import (
	"database/sql"
	"io/ioutil"

	_ "embed"
	. "nglclone/logger"

	"os"

	_ "github.com/mattn/go-sqlite3"
	"go.uber.org/zap"
)

var Db *sql.DB

func readSQLFile(filePath string) (string, error) {
	sqlBytes, err := ioutil.ReadFile(filePath)
	if err != nil {
		return "", err
	}
	return string(sqlBytes), nil
}

func executeSQLFile(db *sql.DB, filePath string) error {
	sqlContent, err := readSQLFile(filePath)
	if err != nil {
		return err
	}

	_, err = db.Exec(sqlContent)
	return err
}

func init() {

	var err error
	Db, err = sql.Open("sqlite3", "./ngl.db")

	if Log == nil {
		InitLogger()
	}

	if err != nil {
		Log.Error("Error Database", zap.Error(err))
	} else {
		Log.Info("Database started")

		migrationFilePath := "migrations/db.sql"
		if _, err := os.Stat(migrationFilePath); err == nil {
			if err := executeSQLFile(Db, migrationFilePath); err != nil {
				Log.Error("Error: ", zap.Error(err))
			}
		} else {
			Log.Error("Migration file not found", zap.String("filePath", migrationFilePath))
		}

		Db.Exec("PRAGMA foreign_keys=ON")
	}

}
