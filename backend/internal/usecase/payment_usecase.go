package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
	"fmt"
)

type PaymentUseCase interface {
	PaymentRequest(c context.Context, query *PaymentParams) *PaymentResulat
	UpdatePaymentStatus(c context.Context, query *PaymentParams) *PaymentResulat
}

type paymentUsecase struct {
	repoW       repository.WalletRepository
	repoP       repository.PaymentRepository
	collectionP string
	collectionW string
}

func NewPaymentUseCase(repoW repository.WalletRepository, repoC repository.PaymentRepository, collectionP string, collectionW string) PaymentUseCase {
	return &paymentUsecase{
		repoW:       repoW,
		repoP:       repoC,
		collectionP: collectionP,
		collectionW: collectionW,
	}
}

func (pu *paymentUsecase) walletVerify(c context.Context, wallet *domain.Wallet) (*domain.Wallet, error) {
	wallet_db, err := pu.repoW.GetWallet(c, pu.collectionW, wallet.UserID)
	if err != nil {
		return wallet_db, err
	}
	if wallet.CCP != wallet_db.CCP || wallet.RIP != wallet_db.RIP ||
		wallet.PaymentMethod != wallet_db.PaymentMethod {
		return wallet_db, fmt.Errorf("wallet information is not correct")
	}
	if !wallet_db.IsCashable {
		return wallet_db, fmt.Errorf("this wallet is not cashable")
	}
	return wallet_db, nil
}

// PaymentRequest implements PaymentUseCase.
func (pu *paymentUsecase) PaymentRequest(c context.Context, query *PaymentParams) *PaymentResulat {
	if query.Data == nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	payment_request := query.Data
	wallet := payment_request.Wallet
	wallet_db, err1 := pu.walletVerify(c, &wallet)
	if err1 != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  err1,
		}
	}
	if payment_request.Amount < 0 || payment_request.Amount > wallet_db.TempAmount {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("you cannot cash out this amount there are some pending requests"),
		}
	}
	payment_request.Wallet = *wallet_db
	wallet_db.TempAmount -= payment_request.Amount
	_, err := pu.repoW.UpdateTempAmount(c, wallet_db)
	if err != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("failed to update temp amount: %v", err),
		}
	}
	record, err := pu.repoP.PaymentRequest(c, payment_request)
	record.Wallet.Amount = wallet_db.Amount
	record.Wallet.TempAmount = wallet_db.TempAmount
	if err != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("internal error: %v", err),
		}
	}
	return &PaymentResulat{
		Data: record,
		Err:  nil,
	}
}

// UpdateCashOutStatus implements CashOutUseCase.
func (cu *paymentUsecase) UpdatePaymentStatus(c context.Context, query *PaymentParams) *PaymentResulat {
	if query.Data == nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("data requeried"),
		}
	}
	payment_request := query.Data
	wallet := query.Data.Wallet
	payment_db, err := cu.repoP.GetPayment(c, payment_request.ID)
	wallet.UserID = payment_db.Wallet.UserID
	if err != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("payment not found"),
		}
	}
	if payment_db.Amount < payment_request.Amount {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("amount is out of range"),
		}
	}
	wallet_db, err := cu.walletVerify(c, &wallet)
	if err != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  err,
		}
	}
	record, err := cu.repoP.UpdatePaymentStatus(c, *payment_request)
	if err != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("failed to update payment status ==> %v", err),
		}
	}
	wallet_db.Amount -= record.Amount
	fmt.Println(wallet_db)
	_, err = cu.repoW.UpdateMyWallet(c, wallet_db)
	if err != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("failed to update wallet ==> %v", err),
		}
	}
	return &PaymentResulat{
		Data: record,
		Err:  nil,
	}
}
