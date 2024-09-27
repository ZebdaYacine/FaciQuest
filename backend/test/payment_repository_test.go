package test

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"log"
	"testing"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func TestPaymentRepository(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db := database.ConnectionDb()
		// db.Collection("payment")
		ctx := context.Background()
		// collection := pr.database.Collection("payment")
		id, err := primitive.ObjectIDFromHex("66cedce1c5e558af943ac0c5")
		if err != nil {
			log.Fatal(err)
		}
		payment := &domain.Payment{}
		filter := bson.D{{Key: "_id", Value: id}}
		db.Collection("payment").FindOne(ctx, filter).Decode(payment)
		log.Println(payment)
		// pr := repository.NewPaymentRepository(db)
		// record, err := pr.GetPayment(ctx, "66cedce1c5e558af943ac0c5")
		// if err == nil {
		// 	fmt.Println(record)
		// }
		// println(err.Error())
		//assert.NoError(t, err)
	})
}
