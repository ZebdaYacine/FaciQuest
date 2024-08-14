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
	Data any
	Err  error
}

var (
	walletResulat = &WalletResulat{}
)

type WalletUseCase interface {

	//WALLET FUNCTIONS
	InitMyWallet(c context.Context, wallet *WalletParams) *WalletResulat
	UpdateMyWallet(c context.Context, wallet *WalletParams) *WalletResulat
	GetWallet(c context.Context, query *WalletParams) *WalletResulat
	CashOutMyWallet(c context.Context, query *WalletParams) *WalletResulat
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

// CashOutMyWallet implements WalletUseCase.
func (wu *walletUsecase) CashOutMyWallet(c context.Context, query *WalletParams) *WalletResulat {
	if query.Data == nil {
		return &WalletResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	wallet := query.Data.(*domain.Wallet)
	record, err := wu.repo.CashOutMyWallet(c, wallet)
	if err != nil {
		return &WalletResulat{
			Data: nil,
			Err:  fmt.Errorf("internal error: %v", err),
		}
	}
	return &WalletResulat{
		Data: record,
		Err:  nil,
	}
}

// GetWalletCashable implements WalletUseCase.
func (wu *walletUsecase) GetWallet(c context.Context, query *WalletParams) *WalletResulat {
	if query.Data == nil {
		return &WalletResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	userId := query.Data.(string)
	wallet, err := wu.repo.GetWallet(c, userId)
	if err != nil {
		return &WalletResulat{
			Data: nil,
			Err:  fmt.Errorf("internal error: %v", err),
		}
	}
	return &WalletResulat{
		Data: wallet,
		Err:  nil,
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

// UpdateMyWallet implements WalletUseCase.
func (wu *walletUsecase) UpdateMyWallet(c context.Context, query *WalletParams) *WalletResulat {
	if query.Data == nil {
		walletResulat.Err = fmt.Errorf("data requeried")
	}
	wallet := query.Data.(domain.Wallet)
	result, err := wu.repo.UpdateMyWallet(c, &wallet)
	if err == nil {
		walletResulat.Err = err
	}
	walletResulat.Data = result
	return walletResulat
}
