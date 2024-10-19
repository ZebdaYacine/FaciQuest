package domain

type Answer struct {
	QuestionID string                 `json:"questionId" bson:"questionId"`
	Details    map[string]interface{} `json:"details" bson:"details"`
}

type Submission struct {
	SurveyID    string   `json:"surveyId"`
	CollectorID string   `json:"collectorId" bson:"collector"`
	Answers     []Answer `json:"answers"`
}
