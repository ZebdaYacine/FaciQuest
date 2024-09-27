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
		if db == nil {
			t.Fatal("Database connection failed")
		}

		ctx := context.Background()
		pr := repository.NewSurveyRepository(db)
		if pr == nil {
			t.Fatal("Failed to create SurveyRepository")
		}

		survey := &domain.Survey{
			ID:          "66f6ca55656638fc88386478",
			Title:       "Customer Satisfaction Survey 2024",
			Description: "A survey to assess customer satisfaction",
			Status:      "active",
			Languages:   []string{"en", "fr"},
			Topics:      []string{"service", "quality"},
			LikertScale: "5-point",
			Questions: []domain.QuestionType{
				domain.MultipleChoiceQuestion{
					BaseQuestion: domain.BaseQuestion{
						Title: "How satisfied were you with our service?",
						Order: 1,
					},
					Choices: []string{
						"Very satisfied",
						"Satisfactory",
						"Neither satisfied nor dissatisfied",
						"Dissatisfied",
						"Very dissatisfied",
					},
				},
				domain.StarRatingQuestion{
					BaseQuestion: domain.BaseQuestion{
						Title: "How satisfied were you with our quality?",
						Order: 2,
					},
					MaxRating: 5,
					Shape:     "circle",
					Color:     "blue",
				},
			}, // Add questions as needed
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

		if err != nil {
			t.Fatal("Failed to update survey:", err)
		}

		fmt.Println(record.Questions[0])
	},
	)
}
