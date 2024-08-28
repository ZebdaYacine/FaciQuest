package test

import (
	"back-end/internal/repository"
	"back-end/pkg/database"
	"context"
	"fmt"
	"testing"
)

func TestPaymentRepository(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db := database.ConnectionDb()
		db.Collection("payment")
		ctx := context.Background()
		pr := repository.NewPaymentRepository(db)
		record, err := pr.GetPayment(ctx, "66cedce1c5e558af943ac0c5")
		if err == nil {
			fmt.Println(record)
		}
		println(err.Error())
		//assert.NoError(t, err)
	})
}
