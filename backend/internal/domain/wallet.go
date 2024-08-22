package domain

type Wallet struct {
	ID            string  `json:"_id"`
	Amount        float64 `json:"amount"`
	NbrSurveys    int64   `json:"nbrsurveys"`
	CCP           string  `json:"ccp"`
	RIP           string  `json:"rip"`
	UserID        string  `json:"userid"`
	PaymentMethod string  `json:"paiementMethode"`
	IsCashable    bool    `json:"iscashable"`
}
