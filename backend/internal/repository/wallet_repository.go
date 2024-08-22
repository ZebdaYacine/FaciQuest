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
	CashOutMyWallet(c context.Context, wallet *domain.CashOut) (*domain.CashOut, error)
	UpdateCashOutStatus(c context.Context, wallet *domain.CashOut) (*domain.CashOut, error)
}

type walletRepository struct {
	database database.Database
}

func NewWalletRepository(db database.Database) WalletRepository {
	return &walletRepository{
		database: db,
	}
}

// UpdateCashOutStatus implements WalletRepository.
func (wr *walletRepository) UpdateCashOutStatus(c context.Context, cashout *domain.CashOut) (*domain.CashOut, error) {
	wallet, err := wr.GetWallet(c, cashout.Wallet.UserID)
	if err != nil {
		return nil, err
	}
	if wallet.Amount < cashout.Amount {
		return nil, fmt.Errorf("wallet amount is out of range: %v", cashout.Amount)
	}
	wallet.Amount -= cashout.Amount
	record, err := wr.UpdateMyWallet(c, wallet)
	if err != nil {
		return nil, err
	}
	cashout.Status = "success"
	cashout.Wallet = *record
	collection := wr.database.Collection("cashout_request")
	filterUpdate := bson.D{{Key: "_id", Value: cashout.ID}}
	update := bson.M{
		"$set": cashout,
	}
	return core.UpdateDoc[domain.CashOut](c, collection, update, filterUpdate)

}

// CashOutMyWallet implements WalletRepository.
func (wr *walletRepository) CashOutMyWallet(c context.Context, data *domain.CashOut) (*domain.CashOut, error) {
	collection := wr.database.Collection("cashout_request")
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

// GetWalletCashable implements WalletRepository.
func (wr *walletRepository) GetWallet(c context.Context, userId string) (*domain.Wallet, error) {
	collection := wr.database.Collection("wallet")
	var resulat bson.M
	filter := bson.D{{Key: "userid", Value: userId}}
	err := collection.FindOne(c, filter).Decode(&resulat)
	if err == mongo.ErrNoDocuments {
		return nil, fmt.Errorf("user has not wallet %s", err.Error())
	}
	return &domain.Wallet{
		ID:            resulat["_id"].(primitive.ObjectID).Hex(),
		UserID:        userId,
		Amount:        resulat["amount"].(float64),
		NbrSurveys:    resulat["nbrsurveys"].(int64),
		CCP:           resulat["ccp"].(string),
		RIP:           resulat["rip"].(string),
		PaymentMethod: resulat["paymentmethod"].(string),
		IsCashable:    resulat["amount"].(float64) >= 1000,
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
			"iscashable":      data.Amount >= 1000,
		},
	}
	return core.UpdateDoc[domain.Wallet](c, collection, update, filterUpdate)
}
