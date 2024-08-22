package usecase

import (
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
	wallet_db, err := pu.repoW.GetWallet(c, pu.collectionW, wallet.UserID)
	payment_request.Wallet.ID = wallet_db.ID
	if err != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("this user has not wallet ==> %v", err),
		}
	}

	if wallet.Amount != wallet_db.Amount ||
		wallet.CCP != wallet_db.CCP || wallet.RIP != wallet_db.RIP ||
		wallet.PaymentMethod != wallet_db.PaymentMethod ||
		wallet.NbrSurveys != wallet_db.NbrSurveys {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("wallet information is not correct"),
		}
	}
	if !wallet_db.IsCashable {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("this wallet is not cashable"),
		}
	}
	payment_request.Wallet = *wallet_db
	if payment_request.Amount < 0 || payment_request.Amount > wallet_db.TempAmount {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("you cannot cash out this amount there are some pending requests"),
		}
	}
	wallet_db.TempAmount -= payment_request.Amount
	_, err = pu.repoW.UpdateMyWallet(c, wallet_db)
	if err != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("Failed to update temp amount: %v", err),
		}
	}
	record, err := pu.repoP.PaymentRequest(c, payment_request)
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
	wallet := payment_request.Wallet
	record, err := cu.repoP.UpdatePaymentStatus(c, *payment_request)
	if err != nil {
		return &PaymentResulat{
			Data: nil,
			Err:  fmt.Errorf("failed to update payment status ==> %v", err),
		}
	}
	wallet.Amount -= record.Amount
	_, err = cu.repoW.UpdateMyWallet(c, &wallet)
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
