package models

import "time"

type Transaction struct {
	Id                   int64     `json:"id"`
	TransactionReference string    `json:"transactionReference"`
	PaymentReference     string    `json:"paymentReference"`
	PaidOn               string    `json:"paidOn"`
	PaymentDescription   string    `json:"paymentDescription"`
	SessionId            string    `json:"sessionId"`
	SenderAccountNumber  string    `json:"senderAccountNumber"`
	SenderAccountName    string    `json:"senderAccountName"`
	SenderBankCode       string    `json:"senderBankCode"`
	AccountId            int64     `json:"accountId"`
	AmountPaid           float64   `json:"amountPaid"`
	SettlementAmount     float64   `json:"settlementAmount"`
	PaymentStatus        string    `json:"paymentStatus"`
	PaymentMethod        string    `json:"paymentMethod"`
	CreatedAt            time.Time `json:"createdAt"`
}

type TransactionEvent struct {
	EventType string    `json:"eventType"`
	EventData EventData `json:"eventData"`
}
type EventData struct {
	Product                       Product                       `json:"product"`
	TransactionReference          string                        `json:"transactionReference"`
	PaymentReference              string                        `json:"paymentReference"`
	PaidOn                        string                        `json:"paidOn"`
	PaymentDescription            string                        `json:"paymentDescription"`
	PaymentSourceInformation      PaymentSourceInformation      `json:"paymentSourceInformation"`
	DestinationAccountInformation DestinationAccountInformation `json:"destinationAccountInformation"`
	AmountPaid                    float64                       `json:"amountPaid"`
	TotalPayable                  float64                       `json:"totalPayable"`
	PaymentMethod                 string                        `json:"paymentMethod"`
	Currency                      string                        `json:"currency"`
	SettlementAmount              float64                       `json:"settlementAmount"`
	PaymentStatus                 string                        `json:"paymentStatus"`
	Customer                      Customer                      `json:"customer"`
}

type PaymentSourceInformation struct {
	BankCode      string  `json:"bankCode"`
	AmountPaid    float64 `json:"amountPaid"`
	AccountName   string  `json:"accountName"`
	SessionId     string  `json:"sessionId"`
	AccountNumber string  `json:"accountNumber"`
}

type DestinationAccountInformation struct {
	BankCode      string `json:"bankCode"`
	AccountName   string `json:"accountName"`
	AccountNumber string `json:"accountNumber"`
}

type Product struct {
	Reference string `json:"reference"`
	Type      string `json:"type"`
}
type Customer struct {
	Name  string `json:"name"`
	Email string `json:"email"`
}

type TransactionRepository interface {
	CreateTransaction(transaction *Transaction) error
	GetTransactions() (*[]Transaction, error)
	GetUserTransactions(accountId int64) (*[]Transaction, error)
	GetTransactionById(id int64) (*Transaction, error)
	UpdateTransaction(id int64) error
}
