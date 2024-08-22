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

type CashOutMyWalletParams struct {
	Data *domain.CashOut
}

type CashOutMyWalletResulat struct {
	Data *domain.CashOut
	Err  error
}

var (
	walletResulat          = &WalletResulat{}
	cashOutMyWalletResulat = &CashOutMyWalletParams{}
)

type WalletUseCase interface {

	//WALLET FUNCTIONS
	InitMyWallet(c context.Context, wallet *WalletParams) *WalletResulat
	UpdateMyWallet(c context.Context, wallet *WalletParams) *WalletResulat
	GetWallet(c context.Context, query *WalletParams) *WalletResulat
	CashOutMyWallet(c context.Context, query *CashOutMyWalletParams) *CashOutMyWalletResulat
	UpdateCashOutStatus(c context.Context, query *CashOutMyWalletParams) *CashOutMyWalletResulat
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

// UpdateCashOutMyWallet implements WalletUseCase.
func (wu *walletUsecase) UpdateCashOutStatus(c context.Context, query *CashOutMyWalletParams) *CashOutMyWalletResulat {
	if query.Data == nil {
		return &CashOutMyWalletResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	cashout_request := query.Data
	wallet := cashout_request.Wallet
	_, err := wu.repo.GetWallet(c, wallet.UserID)
	if err != nil {
		return &CashOutMyWalletResulat{
			Data: nil,
			Err:  fmt.Errorf("this user has not wallet ==> %v", err),
		}
	}
	record, err := wu.repo.UpdateCashOutStatus(c, cashout_request)
	if err != nil {
		return &CashOutMyWalletResulat{
			Data: nil,
			Err:  fmt.Errorf("this user has not wallet ==> %v", err),
		}
	}

	return &CashOutMyWalletResulat{
		Data: record,
		Err:  fmt.Errorf("this user has not wallet ==> %v", err),
	}

}

// CashOutMyWallet implements WalletUseCase.
func (wu *walletUsecase) CashOutMyWallet(c context.Context, query *CashOutMyWalletParams) *CashOutMyWalletResulat {
	if query.Data == nil {
		return &CashOutMyWalletResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	cashout_request := query.Data
	wallet := cashout_request.Wallet
	wallet_db, err := wu.repo.GetWallet(c, wallet.UserID)

	cashout_request.Wallet.ID = *&wallet_db.ID
	if err != nil {
		return &CashOutMyWalletResulat{
			Data: nil,
			Err:  fmt.Errorf("this user has not wallet ==> %v", err),
		}
	}
	if wallet.Amount != wallet_db.Amount ||
		wallet.PaymentMethod != wallet_db.PaymentMethod ||
		wallet.CCP != wallet_db.CCP || wallet.RIP != wallet_db.RIP {
		return &CashOutMyWalletResulat{
			Data: nil,
			Err:  fmt.Errorf("wallet information is not correct"),
		}
	}
	if !wallet_db.IsCashable {
		return &CashOutMyWalletResulat{
			Data: nil,
			Err:  fmt.Errorf("this wallet is not cashable"),
		}
	}
	if cashout_request.Amount < 0 || cashout_request.Amount > wallet.Amount {
		return &CashOutMyWalletResulat{
			Data: nil,
			Err:  fmt.Errorf("you cannot cash out this amount"),
		}
	}
	record, err := wu.repo.CashOutMyWallet(c, cashout_request)
	if err != nil {
		return &CashOutMyWalletResulat{
			Data: nil,
			Err:  fmt.Errorf("internal error: %v", err),
		}
	}
	return &CashOutMyWalletResulat{
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
