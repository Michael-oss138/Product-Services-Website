package handlers

import (
	"net/http"

	"educesol.com/payment-service/internal/models"
	"educesol.com/payment-service/internal/services"
	"github.com/gin-gonic/gin"
)

type AccountHandler struct {
	service *services.AccountService
}

func NewAccountHandler(service *services.AccountService) *AccountHandler {
	return &AccountHandler{service: service}
}
func (ah *AccountHandler) CreateAccount(c *gin.Context) {
	var AccountRequest models.CreateAccountRequest
	err := c.ShouldBindJSON(&AccountRequest)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": err.Error()})
		return
	}
	err = ah.service.CreateVirtualAccount(&AccountRequest)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Account created!"})

}
func (ah *AccountHandler) GetAllVirtualAccounts(c *gin.Context) {
	accounts, err := ah.service.GetAllVirtualAccounts()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Accounts retrieved!", "data": accounts})

}
func (ah *AccountHandler) GetUserAccount(c *gin.Context) {
	userId := c.Param("userId")
	account, err := ah.service.GetUserAccount(userId)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Accounts retrieved!", "data": account})
}
