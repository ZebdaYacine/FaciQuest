package domain

type User struct {
	ID           string `json:"_id"`
	Username     string `json:"username"`
	FirstName    string `json:"firstname"`
	LastName     string `json:"lastname"`
	Email        string `json:"email"`
	Phone        string `json:"phone"`
	PassWord     string `json:"password"`
	Birthdate    string `json:"birthDate"`
	Age          int64  `json:"age"`
	BirthPlace   string `json:"birthPlace"`
	Country      string `json:"country"`
	Municipal    string `json:"municipal"`
	Education    string `json:"education"`
	WorkerAt     string `json:"workerAt"`
	Institution  string `json:"institution"`
	SocialStatus string `json:"socialStatus"`
	Role         string `json:"role"`
	ImageUrl     string `json:"imageUrl"`
	BDD          int64  `json:"bdd"`
}
