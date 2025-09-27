package domain

type Wallet struct {
	ID            string  `json:"_id"`
	Amount        float64 `json:"amount" bson:"amount"`
	// TempAmount    float64 `json:"temp_amount" bson:"temp_amount"`
	NbrSurveys    int64   `json:"nbr_surveys" bson:"nbr_surveys"`
	CCP           string  `json:"ccp" bson:"ccp"`
	RIP           string  `json:"rip" bson:"rip"`
	UserID        string  `json:"userid" bson:"userid"`
	PaymentMethod string  `json:"payment_method" bson:"payment_method"`
	IsCashable    bool    `json:"is_cashable" bson:"is_cashable"`
}
