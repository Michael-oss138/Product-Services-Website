package services

import (
	"educesol.com/payment-service/internal/models"
	"educesol.com/payment-service/pkg/clients/monnify"
)

type AccountService struct {
	repo models.AccountRepository
}

func NewAccountService(repo models.AccountRepository) *AccountService {
	return &AccountService{repo: repo}
}

func (as *AccountService) CreateVirtualAccount(req *models.CreateAccountRequest) error {
	accountDetails, err := monnify.CreateVirtualAccount(req)
	if err != nil {
		return err
	}
	err = as.repo.CreateAccount(accountDetails)
	if err != nil {
		return err
	}
	return nil
}
func (as *AccountService) GetAllVirtualAccounts() (*[]models.Account, error) {
	return as.repo.GetAccounts()
}
func (as *AccountService) GetUserAccount(userId string) (*models.Account, error) {
	return as.repo.GetUserAccount(userId)
}
