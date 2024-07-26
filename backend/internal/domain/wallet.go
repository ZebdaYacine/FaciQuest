package domain

type HtlmlMsgWallet struct {
	FirstName string
	LastName  string
	CCP       string
	Amount    string
}

type Wallet struct {
	ID            string  `json:"_id"`
	Amount        float32 `json:"amount"`
	NbrSurveys    int64   `json:"nbrsurveys"`
	CCP           string  `json:"ccp"`
	UserID        string  `json:"userid"`
	PaymentMethod string  `json:"PaiementMethode"`
}
