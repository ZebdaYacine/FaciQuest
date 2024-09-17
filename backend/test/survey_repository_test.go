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
		record, err := pr.CreateSurvey(ctx, &domain.Survey{})
		if err == nil {
			fmt.Println(record)
		}
		println(err.Error())

	})
}
