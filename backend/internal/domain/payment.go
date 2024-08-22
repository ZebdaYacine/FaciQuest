package domain

type Payment struct {
	ID                 string  `json:"_id" `
	Wallet             Wallet  `json:"wallet" bson:"wallet"`
	PaymentRequestDate string  `json:"payment_request_date" bson:"payment_request_date"`
	Amount             float64 `json:"amount" bson:"amount"`
	Status             string  `json:"status" bson:"status"`
	PaymentDate        string  `json:"payment_date" bson:"payment_date"`
}
