package repository

import (
	"back-end/core"
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"log"

	"go.mongodb.org/mongo-driver/bson"
)

type WalletRepository interface {
	InitMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error)
	UpdateMyWallet(c context.Context, wallet *domain.Wallet) (*domain.Wallet, error)
}

type walletRepository struct {
	database database.Database
}

func NewWalletRepository(db database.Database) WalletRepository {
	return &walletRepository{
		database: db,
	}
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
