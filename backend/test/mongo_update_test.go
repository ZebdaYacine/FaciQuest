package test

import (
	// "back-end/internal/domain"

	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"testing"

	"go.mongodb.org/mongo-driver/bson"
)

func TestMongoUpdate(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db := database.ConnectionDb()
		collection := db.Collection("cashout_request")
		filterUpdate := bson.M{"_id": "66ee9278bbb036695b75ca49"}
		update := bson.M{"$set": 
		domain.Payment{
			PaymentRequestDate: 1727481600000,
			Amount:             10000,
			Status:             "Pending",
			PaymentDate:        1727481600000, // Empty for pending
		}}
		updateResult, err := collection.UpdateOne(context.TODO(), filterUpdate, update)
		if err != nil {
			fmt.Errorf(err.Error())
		}
		fmt.Printf("Matched %v documents and modified %v documents.\n", updateResult.MatchedCount, updateResult.ModifiedCount)

		//assert.NoError(t, err1)
	})

}
