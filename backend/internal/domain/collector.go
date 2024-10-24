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
	GenderName string `json:"genderName" bson:"genderName"`
}

type AgeRange struct {
	MinAge int `json:"minAge"`
	MaxAge int `json:"maxAge"`
}

type TargetAudience struct {
	Population        int        `json:"population" bson:"population"`
	Gender            []Gender   `json:"gender" bson:"gender"`
	AgeRange          []AgeRange `json:"ageRange" bson:"ageRange"`
	Location          Location   `json:"location" bson:"location"`
	TargetingCriteria []Criteria `json:"targetingCriteria" bson:"targetingCriteria"`
}

type WebCollector struct {
	WebURL string `json:"webUrl,omitempty" bson:"webUrl"`
}

func (c *Collector) Validate() error {
	if c.Type == WebLink {
		if c.WebCollector.WebURL == "" {
			return fmt.Errorf("webCollector.webUrl is required for webLink collector type")
		}
	}
	if c.Type == Audience {
		if c.TargetAudience.Population == 0 ||
			len(c.TargetAudience.Gender) == 0 ||
			len(c.TargetAudience.AgeRange) == 0 {
			/*||
			len(c.TargetAudience.TargetingCriteria) == 0 */
			return fmt.Errorf("audience is required for TargetAudience type")
		}
	}
	return nil
}
