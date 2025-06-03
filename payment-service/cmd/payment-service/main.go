package main

import (
	"log"

	"educesol.com/payment-service/internal/handlers"
	"educesol.com/payment-service/internal/repository"
	"educesol.com/payment-service/internal/routes"
	"educesol.com/payment-service/internal/services"
	"educesol.com/payment-service/pkg/database"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	server := gin.Default()
	if err != nil {
		log.Fatal("Error loading dotenv file")
	}
	db := database.Initialize()
	accountRepository := repository.NewAccountRepository(db)
	accountService := services.NewAccountService(accountRepository)
	accountHandler := handlers.NewAccountHandler(accountService)
	routes.RegisterAccountRoutes(server, accountHandler)
	server.Run(":4040")
}
