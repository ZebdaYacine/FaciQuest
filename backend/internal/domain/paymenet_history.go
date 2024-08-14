package domain

type CashoutRequest struct {
	ID                 string `json:"_id"`
	Wallet             Wallet `json:"wallet"`
	CashoutRequestDate string `json:"cashout_request_date"`
	Status             string `json:"status"`
	PaymentDate        string `json:"payment_date"`
}
