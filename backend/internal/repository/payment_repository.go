package repository

import (
	"back-end/core"
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type PaymentRepository interface {
	GetPayment(c context.Context, paymentID string) (*domain.Payment, error)
	PaymentRequest(c context.Context, wallet *domain.Payment) (*domain.Payment, error)
	UpdatePaymentStatus(c context.Context, record domain.Payment) (*domain.Payment, error)
}

type paymentRepository struct {
	database database.Database
}

func NewPaymentRepository(db database.Database) PaymentRepository {
	return &paymentRepository{
		database: db,
	}
}

// GetPayment implements PaymentRepository.
func (pr *paymentRepository) GetPayment(c context.Context, paymentID string) (*domain.Payment, error) {
	collection := pr.database.Collection("payment")
	id, err := primitive.ObjectIDFromHex(paymentID)
	if err != nil {
		log.Fatal(err)
	}
	var payment domain.Payment
	filter := bson.D{{Key: "_id", Value: id}}
	err = collection.FindOne(c, filter).Decode(&payment)
	if err == mongo.ErrNoDocuments {
		return nil, fmt.Errorf("user has not wallet %s", err.Error())
	}
	payment.ID = paymentID
	return &payment, nil
}

// PaymentRequest implements WalletRepository.
func (pr *paymentRepository) PaymentRequest(c context.Context, data *domain.Payment) (*domain.Payment, error) {
	collection := pr.database.Collection("payment")
	record := data
	requestId, err := collection.InsertOne(c, record)
	if err != nil {
		log.Printf("Failed to record cash out request: %v", err)
		return nil, err
	}
	log.Printf("record cash out request ID %v :", requestId)
	record.ID = requestId.(string)
	return record, nil
}

// UpdatePaymentStatus implements CashoutRepository.
func (pr *paymentRepository) UpdatePaymentStatus(c context.Context, record domain.Payment) (*domain.Payment, error) {
	collection := pr.database.Collection("payment")
	objectID, err := primitive.ObjectIDFromHex(record.ID)
	if err != nil {
		return nil, fmt.Errorf("error creating payment object")
	}
	filterUpdate := bson.D{{Key: "_id", Value: objectID}}
	update := bson.M{
		"$set": bson.M{
			"status":       record.Status,
			"payment_date": record.PaymentDate,
		},
	}
	return core.UpdateDoc[domain.Payment](c, collection, update, filterUpdate)
}
