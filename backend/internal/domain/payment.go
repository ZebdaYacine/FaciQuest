package domain

type Payment struct {
	ID                 string  `json:"_id" `
	Wallet             Wallet  `json:"wallet" bson:"wallet"`
	PaymentRequestDate int64   `json:"payment_request_date" bson:"payment_request_date"`
	Amount             float64 `json:"amount" bson:"amount"`
	Status             string  `json:"status" bson:"status"`
	PaymentDate        int64   `json:"payment_date" bson:"payment_date"`
}

type ConfirmPayment struct {
	CollectorId    string `json:"collectorId" bson:"collectorId"`
	ProofOfPayment string `json:"proof_of_payment" bson:"proof_of_payment"`
	FileName       string `json:"file_name" bson:"file_name"`
}
