package test

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"back-end/pkg/database"
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestWalletRepository(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db := database.ConnectionDb()
		db.Collection("wallet")
		ctx := context.Background()
		wr := repository.NewWalletRepository(db)
		wallet := domain.Wallet{
			Amount: 19000,
			UserID: "66c4f115033a5509879b67e9",
		}
		record, err := wr.UpdateMyWallet(ctx, &wallet)
		if err == nil {
			print(record)
		}
		assert.NoError(t, err)
	})
}
