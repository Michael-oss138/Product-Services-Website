package config
import (
	"os"
)

type SecurityConfig struct{
	MonnifyKey string
	MonnifyContractCode string
	DatabaseUrl string
}

func NewSecurityConfig() *SecurityConfig{
	return &SecurityConfig{
		MonnifyKey:os.Getenv("MONNIFY_KEY"),
		DatabaseUrl:os.Getenv("DATABASE_URL"),
		MonnifyContractCode:os.Getenv("MONNIFY_CONTRACT_CODE"),
	}
}