package repository

import (
	"database/sql"

	"educesol.com/payment-service/internal/models"
)

type TransactionRepository struct {
	db *sql.DB
}

func NewTransactionRepository(db *sql.DB) models.TransactionRepository {
	return &TransactionRepository{db: db}
}

func (tr TransactionRepository) CreateTransaction(transaction *models.Transaction) error {
	return nil
}
func (tr TransactionRepository) GetTransactions() (*[]models.Transaction, error) {
	return nil, nil
}

func (tr TransactionRepository) GetUserTransactions(accountId int64) (*[]models.Transaction, error) {
	return nil, nil
}
func (tr TransactionRepository) GetTransactionById(id int64) (*models.Transaction, error) {
	return nil, nil
}
func (tr TransactionRepository) UpdateTransaction(id int64) error {
	return nil
}
