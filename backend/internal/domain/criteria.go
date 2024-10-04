package domain

type Criteria struct {
	ID          string   `json:"id" bson:"id"`
	Title       string   `json:"title" bson:"title"`
	Description string   `json:"description" bson:"description"`
	Choices     []string `json:"choices" bson:"choices"`
	Category    Category `json:"category" bson:"category"`
}

type Category struct {
	ID   string `json:"id" bson:"id"`
	Name string `json:"Name" bson:"Name"`
}
