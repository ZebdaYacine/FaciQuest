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
		id := "6718cf4f9ae8e7dfee72ab5f"
		r, err := pr.DeleteCollector(ctx, id)
		if err != nil {
			t.Fatalf("Failed to delete collector: %v", err)
		}
		log.Println(r)
	})
}

func TestGetCollectorRepository(t *testing.T) {
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
		surevyId := "672965669b126308f923c27b"
		r, err := pr.GetCollector(ctx, "66ced91b015ced6ece935ed4", surevyId)
		log.Println(err)
		if err != nil {
			t.Fatalf("Failed to Get collector: %v", err)
		}
		log.Println(r)
	})
}
