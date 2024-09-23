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
			ID:          "66ee9278bbb036695b75ca49",
			Title:       "Customer Satisfaction Survey 2024",
			Description: "A survey to assess customer satisfaction",
			Status:      "active",
			Languages:   []string{"en", "fr"},
			Topics:      []string{"service", "quality"},
			LikertScale: "5-point",
			Questions:   []domain.QuestionType{}, // Add questions as needed
			Sample: domain.Sample{
				Size: 1000,
				Type: "random",
				Location: domain.Location{
					Country: "USA",
					State:   []string{"California"},
					City:    []string{"San Francisco"},
				},
			},
		}
		record, err := pr.UpdateSurvey(ctx, survey)
		if err == nil {
			fmt.Println(record)
		}
		println(err.Error())

	})
}
