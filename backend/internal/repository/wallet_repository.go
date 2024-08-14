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

type WalletRepository interface {
	InitMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error)
	UpdateMyWallet(c context.Context, wallet *domain.Wallet) (*domain.Wallet, error)
	GetWallet(c context.Context, userId string) (*domain.Wallet, error)
	CashOutMyWallet(c context.Context, wallet *domain.Wallet) (*domain.CashoutRequest, error)
}

type walletRepository struct {
	database database.Database
}

func NewWalletRepository(db database.Database) WalletRepository {
	return &walletRepository{
		database: db,
	}
}

// CashOutMyWallet implements WalletRepository.
func (wr *walletRepository) CashOutMyWallet(c context.Context, wallet *domain.Wallet) (*domain.CashoutRequest, error) {
	collection := wr.database.Collection("cashout_request")
	record := &domain.CashoutRequest{
		Wallet:             *wallet,
		CashoutRequestDate: "",
		Status:             "pending",
		PaymentDate:        "",
	}
	requestId, err := collection.InsertOne(c, record)
	if err != nil {
		log.Printf("Failed to record cash out request: %v", err)
		return nil, err
	}
	log.Printf("record cash out request ID %v :", requestId)
	return record, nil
}

// GetWalletCashable implements WalletRepository.
func (wr *walletRepository) GetWallet(c context.Context, userId string) (*domain.Wallet, error) {
	collection := wr.database.Collection("wallet")
	var resulat bson.M
	filter := bson.D{{Key: "userid", Value: userId}}
	err := collection.FindOne(c, filter).Decode(&resulat)
	if err != mongo.ErrNoDocuments {
		return nil, fmt.Errorf("user has not wallet")
	}
	return &domain.Wallet{
		ID:            resulat["_id"].(primitive.ObjectID).Hex(),
		UserID:        userId,
		Amount:        resulat["amount"].(float32),
		NbrSurveys:    resulat["nbrsurveys"].(int64),
		CCP:           resulat["ccp"].(string),
		RIP:           resulat["rip"].(string),
		PaymentMethod: resulat["PaiementMethode"].(string),
		IsCashable:    resulat["amount"].(float32) >= 1000,
	}, nil
}

// InitMyWallet implements WalletRepository.
func (wr *walletRepository) InitMyWallet(c context.Context, data *domain.User) (*domain.Wallet, error) {
	collection := wr.database.Collection("wallet")
	wallet := &domain.Wallet{
		Amount:        0,
		NbrSurveys:    0,
		CCP:           "",
		RIP:           "",
		PaymentMethod: "",
		UserID:        data.ID,
	}
	walletID, err1 := collection.InsertOne(c, wallet)
	if err1 != nil {
		log.Printf("Failed to init wallet: %v", err1)
		return nil, err1
	}
	log.Printf("Init wallet  with id %v", walletID)
	wallet.ID = walletID.(string)
	return wallet, nil
}

// UpdateMyWallet implements WalletRepository.
func (wr *walletRepository) UpdateMyWallet(c context.Context, data *domain.Wallet) (*domain.Wallet, error) {
	collection := wr.database.Collection("wallet")
	filterUpdate := bson.D{{Key: "userid", Value: data.UserID}}
	update := bson.M{
		"$set": bson.M{
			"amount":          data.Amount,
			"nbrsurveys":      data.NbrSurveys,
			"ccp":             data.CCP,
			"rip":             data.RIP,
			"userid":          data.UserID,
			"PaiementMethode": data.PaymentMethod,
		},
	}
	return core.UpdateDoc[domain.Wallet](c, collection, update, filterUpdate)
}
