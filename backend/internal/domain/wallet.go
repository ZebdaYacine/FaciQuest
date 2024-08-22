package domain

type Wallet struct {
	ID            string  `json:"_id"`
	Amount        float64 `json:"amount"`
	TempAmount    float64 `json:"temp_amount"`
	NbrSurveys    int64   `json:"nbrsurveys"`
	CCP           string  `json:"ccp"`
	RIP           string  `json:"rip"`
	UserID        string  `json:"userid"`
	PaymentMethod string  `json:"paymentMethod"`
	IsCashable    bool    `json:"iscashable"`
}
