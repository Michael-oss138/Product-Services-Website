package utils

import (
	"crypto/rand"
	"encoding/base64"
	"math/big"
)

func GenerateRandomNumbers(length int64) (*big.Int, error) {
	min := new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(length-1)), nil)
	max := new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(length)), nil)
	n, err := rand.Int(rand.Reader, max.Sub(max, min))
	if err != nil {
		return big.NewInt(0), nil
	}
	return n.Add(n, min), nil
}

func GenerateRandomStrings(length int64) (string, error) {
	randomBytes := make([]byte, length)
	_, err := rand.Read(randomBytes)
	if err != nil {
		return "", nil
	}
	return base64.URLEncoding.EncodeToString(randomBytes), nil
}
