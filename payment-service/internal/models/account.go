package models

import "time"

type Account struct {
	Id               int64     `json:"id"`
	UserId           string    `json:"userId"`
	ContractCode     string    `json:"contractCode"`
	AccountReference string    `json:"accountReference"`
	AccountNumber    string    `json:"accountNumber"`
	AccountName      string    `json:"accountName"`
	BankName         string    `json:"bankName"`
	BankCode         string    `json:"bankCode"`
	CurrencyCode     string    `json:"currencyCode"`
	CustomerName     string    `json:"customerName"`
	CustomerEmail    string    `json:"customerEmail"`
	AccountBalance   float64   `json:"accountBalance"`
	CreatedAt        time.Time `json:"createdAt"`
	UpdatedAt        time.Time `json:"updatedAt"`
}
type CreateAccountRequest struct {
	UserId        string `binding:"required" json:"userId"`
	CurrencyCode  string `binding:"required" json:"currencyCode"`
	AccountName   string `binding:"required" json:"accountName"`
	CustomerEmail string `binding:"required" json:"customerEmail"`
	BVN           string `json:"bvn"`
	NIN           string `json:"nin"`
}
type AccountDetails struct {
	AccountNumber string `json:"accountNumber"`
	AccountName   string `json:"accountName"`
	BankName      string `json:"bankName"`
	BankCode      string `json:"bankCode"`
}
type CreateAccountResponse struct {
	ContractCode     string           `json:"contractCode"`
	AccountReference string           `json:"accountReference"`
	AccountName      string           `json:"accountName"`
	CurrencyCode     string           `json:"currencyCode"`
	Accounts         []AccountDetails `json:"accounts"`
	CustomerName     string           `json:"customerName"`
	CustomerEmail    string           `json:"customerEmail"`
	Status           string           `json:"status"`
}
type RequestResponse struct {
	RequestSuccessful bool                  `json:"requestSuccessful"`
	ResponseCode      string                `json:"responseCode"`
	ResponseMessage   string                `json:"responseMessage"`
	ResponseBody      CreateAccountResponse `json:"responseBody"`
}
type AccountRepository interface {
	CreateAccount(details *Account) error
	GetAccounts() (*[]Account, error)
	GetUserAccount(userId string) (*Account, error)
}
