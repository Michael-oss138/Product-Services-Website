package monnify

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"educesol.com/payment-service/internal/models"
	"educesol.com/payment-service/internal/utils"
	"educesol.com/payment-service/config"
)

func GenerateAccessToken() {

}
func CreateVirtualAccount(req *models.CreateAccountRequest) (*models.Account, error) {
	conf := config.NewSecurityConfig() 
	accountReference, err := utils.GenerateRandomStrings(12)
	if err != nil {
		return nil, err
	}
	fmt.Println(accountReference)
	payload := map[string]any{
		"accountReference":     accountReference,
		"contractCode":         conf.MonnifyContractCode,
		"currencyCode":         req.CurrencyCode,
		"accountName":          req.AccountName,
		"customerEmail":        req.CustomerEmail,
		"getAllAvailableBanks": true,
		"nin":                  req.NIN,
	}
	jsonBody, err := json.Marshal(payload)
	if err != nil {
		return nil, err
	}
	client := &http.Client{}
	request, err := http.NewRequest("POST", "https://sandbox.monnify.com/api/v2/bank-transfer/reserved-accounts", bytes.NewBuffer(jsonBody))
	if err != nil {
		return nil, err
	}
	request.Header.Set("Authorization", fmt.Sprintf("Bearer %v", conf.MonnifyKey))
	request.Header.Set("Content-Type", "application/json")
	resp, err := client.Do(request)
	if err != nil {
		return nil, err
	}
	if resp.StatusCode != http.StatusOK {
		bodyByte, _ := io.ReadAll(resp.Body)
		log.Printf("%s", string(bodyByte))
		return nil, fmt.Errorf("API Request failed with status %v", resp.Status)
	}
	defer resp.Body.Close()
	var requestResponse models.RequestResponse
	err = json.NewDecoder(resp.Body).Decode(&requestResponse)
	response := requestResponse.ResponseBody
	if err != nil {
		return nil, err
	}
	userData := models.Account{
		UserId:           req.UserId,
		ContractCode:     response.ContractCode,
		AccountReference: response.AccountReference,
		AccountNumber:    response.Accounts[0].AccountNumber,
		AccountName:      response.Accounts[0].AccountName,
		BankName:         response.Accounts[0].BankName,
		BankCode:         response.Accounts[0].BankCode,
		CurrencyCode:     response.CurrencyCode,
		CustomerName:     req.AccountName,
		CustomerEmail:    response.CustomerEmail,
	}
	return &userData, nil

}
