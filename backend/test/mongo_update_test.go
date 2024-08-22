package test

import (
	// "back-end/internal/domain"

	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"testing"
	"time"

	"go.mongodb.org/mongo-driver/bson"
)

func TestMongoUpdate(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db := database.ConnectionDb()
		collection := db.Collection("cashout_request")
		filterUpdate := bson.M{"_id": "66c082ece10917c71ca7f98c"}
		update := bson.M{"$set": domain.Payment{
			PaymentRequestDate: time.Now().Format("2006-01-02T15:04:05Z07:00"),
			Amount:             150.75,
			Status:             "Pending",
			PaymentDate:        "", // Empty for pending
		}}
		updateResult, err := collection.UpdateOne(context.TODO(), filterUpdate, update)
		if err != nil {
			fmt.Errorf(err.Error())
		}
		fmt.Printf("Matched %v documents and modified %v documents.\n", updateResult.MatchedCount, updateResult.ModifiedCount)

		//assert.NoError(t, err1)
	})

}
