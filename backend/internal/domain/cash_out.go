package domain

type CashOut struct {
	ID                 string  `json:"_id" `
	Wallet             Wallet  `json:"wallet" bson:"wallet"`
	CashoutRequestDate string  `json:"cashout_request_date" bson:"cashout_request_date"`
	Amount             float64 `json:"amount" bson:"amount"`
	Status             string  `json:"status" bson:"status"`
	PaymentDate        string  `json:"payment_date" bson:"payment_date"`
}
