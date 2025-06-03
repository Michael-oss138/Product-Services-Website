package routes

import (
	"educesol.com/payment-service/internal/handlers"
	"github.com/gin-gonic/gin"
)

func RegisterAccountRoutes(server *gin.Engine, accountHandler *handlers.AccountHandler) {
	router := server.Group("/accounts")
	router.GET("/", accountHandler.GetAllVirtualAccounts)
	router.POST("/", accountHandler.CreateAccount)
	router.GET("/:userId", accountHandler.GetUserAccount)

}
