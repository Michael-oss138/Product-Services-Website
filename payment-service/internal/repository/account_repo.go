package repository

import (
	"database/sql"
	"errors"

	"educesol.com/payment-service/internal/models"
)

type AccountRepository struct {
	db *sql.DB
}

func NewAccountRepository(db *sql.DB) models.AccountRepository {
	return &AccountRepository{db: db}
}

func (ar *AccountRepository) CreateAccount(account *models.Account) error {
	query := `INSERT INTO accounts(
     userId,contractCode,accountReference,AccountNumber,AccountName,
	 bankName,bankCode,currencyCode,customerName,customerEmail
   ) VALUES(?,?,?,?,?,?,?,?,?,?)
   `
	stmt, err := ar.db.Prepare(query)
	if err != nil {
		return err
	}
	defer stmt.Close()
	_, err = stmt.Exec(account.UserId, account.ContractCode, account.AccountReference, account.AccountNumber, account.AccountName, account.BankName, account.BankCode, account.CurrencyCode, account.CustomerName, account.CustomerEmail)
	if err != nil {
		return err
	}
	return nil
}

func (ar *AccountRepository) GetAccounts() (*[]models.Account, error) {
	accounts := make([]models.Account, 0)
	query := `SELECT * FROM accounts`
	rows, err := ar.db.Query(query)
	if err != nil {
		return nil, err
	}
	for rows.Next() {
		var account models.Account
		err := rows.Scan(&account.Id, &account.UserId, &account.ContractCode, &account.AccountReference, &account.AccountNumber, &account.AccountName, &account.BankName, &account.BankCode, &account.CurrencyCode, &account.CustomerName, &account.CustomerEmail, &account.CreatedAt, &account.UpdatedAt)
		if err != nil {
			return nil, err
		}
		accounts = append(accounts, account)
	}
	return &accounts, nil
}
func (ar *AccountRepository) GetUserAccount(userId string) (*models.Account, error) {
	query := `SELECT * FROM accounts WHERE userId = ?`
	stmt, err := ar.db.Prepare(query)
	if err != nil {
		return nil, err
	}
	row := stmt.QueryRow(userId)
	var account models.Account
	err = row.Scan(&account.Id, &account.UserId, &account.ContractCode, &account.AccountReference, &account.AccountNumber, &account.AccountName, &account.BankName, &account.BankCode, &account.CurrencyCode, &account.CustomerName, &account.CustomerEmail, &account.CreatedAt, &account.UpdatedAt)
	if err != nil {
		return nil, errors.New("no account record exists with provided userId")
	}
	return &account, nil
}
