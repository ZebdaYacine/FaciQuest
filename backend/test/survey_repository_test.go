package test

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"back-end/pkg/database"
	"context"
	"fmt"
	"testing"
)

func TestSurveyRepository(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db := database.ConnectionDb()
		db.Collection("survey")
		ctx := context.Background()
		pr := repository.NewSurveyRepository(db)
		survey := &domain.Survey{
			Title:       "Customer Satisfaction Survey",
			Description: "A survey to assess customer satisfaction",
			Status:      "active",
			Languages:   []string{"en", "fr"},
			Topics:      []string{"service", "quality"},
			LikertScale: "5-point",
			Questions:   []domain.QuestionType{}, // Add questions as needed
			Sample: domain.Sample{
				Size: 100,
				Type: "random",
				Location: domain.Location{
					Country: "USA",
					State:   []string{"California"},
					City:    []string{"San Francisco"},
				},
			},
		}
		record, err := pr.CreateSurvey(ctx, survey)
		if err == nil {
			fmt.Println(record)
		}
		println(err.Error())

	})
}
