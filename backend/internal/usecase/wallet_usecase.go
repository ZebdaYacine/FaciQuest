package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
	"fmt"
)

type WalletParams struct {
	Data any
}

type WalletResulat struct {
	Data *domain.Wallet
	Err  error
}

var (
	walletResulat = &WalletResulat{}
)

type WalletUseCase interface {

	//WALLET FUNCTIONS
	InitMyWallet(c context.Context, wallet *WalletParams) *WalletResulat
	// UpdateMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error)
	// CheckMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error)
}

type walletUsecase struct {
	repo       repository.WalletRepository
	collection string
}

func NewWalletUsecase(repo repository.WalletRepository, collection string) WalletUseCase {
	return &walletUsecase{
		repo:       repo,
		collection: collection,
	}
}

// InitMyWallet implements domain.UserUsecase.
func (wu *walletUsecase) InitMyWallet(c context.Context, query *WalletParams) *WalletResulat {
	if query.Data == nil {
		walletResulat.Err = fmt.Errorf("data requeried")
	}
	user := query.Data.(*domain.User)
	wallet, err := wu.repo.InitMyWallet(c, user)
	if err == nil {
		walletResulat.Err = err

	}
	walletResulat.Data = wallet
	return walletResulat
}
