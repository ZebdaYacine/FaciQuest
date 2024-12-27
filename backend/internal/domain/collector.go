package domain

import "fmt"

type CollectorType string

const (
	Audience CollectorType = "targetAudience"
	WebLink  CollectorType = "webCollector"
)

type Collector struct {
	ID             string         `json:"id" bson:"id"`
	Name           string         `json:"name" bson:"name"`
	Type           CollectorType  `json:"type" bson:"type"`
	SurveyId       string         `json:"surveyId" bson:"surveyId"`
	TargetAudience TargetAudience `json:"targetAudience,omitempty" bson:"targetAudience"`
	WebCollector   WebCollector   `json:"webCollector,omitempty" bson:"webCollector"`
}

type Gender struct {
	Value string `json:"value" bson:"value"`
}

type AgeRange struct {
	Start int `json:"start" bson:"start"`
	End   int `json:"end" bson:"end"`
}

type TargetAudience struct {
	Population        int        `json:"population" bson:"population"`
	Gender            string     `json:"gender" bson:"gender"`
	AgeRange          AgeRange   `json:"ageRange" bson:"ageRange"`
	Countries         []string   `json:"countries" bson:"countries"`
	Provinces         []string   `json:"provinces,omitempty" bson:"provinces,omitempty"`
	Cities            []string   `json:"cities,omitempty" bson:"cities,omitempty"`
	TargetingCriteria []Criteria `json:"targetingCriteria,omitempty" bson:"targetingCriteria,omitempty"`
}

type WebCollector struct {
	WebURL string `json:"webUrl,omitempty" bson:"webUrl"`
}

func (c *Collector) Validate() error {
	// Validate WebLink type
	if c.Type == WebLink {
		if c.WebCollector.WebURL == "" {
			return fmt.Errorf("webCollector.webUrl is required for webLink collector type")
		}
	}

	// Validate Audience type
	if c.Type == Audience {
		if c.TargetAudience.Population <= 0 {
			return fmt.Errorf("targetAudience.population must be greater than 0")
		}
		if c.TargetAudience.Gender == "" {
			return fmt.Errorf("targetAudience.gender is required")
		}
		if c.TargetAudience.AgeRange.Start <= 0 || c.TargetAudience.AgeRange.End <= 0 {
			return fmt.Errorf("targetAudience.ageRange start and end must be greater than 0")
		}
		if c.TargetAudience.AgeRange.Start >= c.TargetAudience.AgeRange.End {
			return fmt.Errorf("targetAudience.ageRange start must be less than end")
		}
	}

	return nil
}
