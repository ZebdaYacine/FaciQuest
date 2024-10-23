package test

import (
	"back-end/internal/repository"
	"back-end/pkg/database"
	"context"
	"log"
	"testing"
)

func TestDeleteCollectorRepository(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db := database.ConnectionDb()
		if db == nil {
			t.Fatal("Database connection failed")
		}
		ctx := context.Background()
		pr := repository.NewCollectorRepository(db)
		if pr == nil {
			t.Fatal("Failed to init CollectorRepository")
		}
		id := "6718cea49ae8e7dfee72ab5e"
		r, err := pr.DeleteCollector(ctx, id)
		if err != nil {
			t.Fatalf("Failed to delete collector: %v", err)
		}
		log.Println(r)
	})
}
