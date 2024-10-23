package domain

type Answer struct {
	QuestionID string `json:"questionId" bson:"questionId"`

	Value string `json:"value,omitempty" bson:"value,omitempty"`

	Rating string `json:"rating,omitempty" bson:"rating,omitempty"`

	StreetAddress1 string `json:"streetAddress1,omitempty" bson:"streetAddress1,omitempty"`
	StreetAddress2 string `json:"streetAddress2,omitempty" bson:"streetAddress2,omitempty"`
	City           string `json:"city,omitempty" bson:"city,omitempty"`
	State          string `json:"state,omitempty" bson:"state,omitempty"`
	PostalCode     string `json:"postalCode,omitempty" bson:"postalCode,omitempty"`
	Country        string `json:"country,omitempty" bson:"country,omitempty"`
}

type Submission struct {
	SurveyID    string   `json:"surveyId" bson:"surveyId"`
	CollectorID string   `json:"collectorId" bson:"collectorId"`
	Answers     []Answer `json:"answers" bson:"answers"`
}
