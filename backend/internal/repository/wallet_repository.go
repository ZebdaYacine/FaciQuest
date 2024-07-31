package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"log"
)

type WalletRepository interface {
	//WALLET FUNCTIONS
	InitMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error)
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
