package test

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"
	"testing"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
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
		id, err := primitive.ObjectIDFromHex("66f70b3d16d7d7eaea313efc")
		if err != nil {
			log.Fatal(err)
		}
		filterUpdate := bson.D{{Key: "_id", Value: id}}
		collection := db.Collection("survey")

		// Fetch the raw BSON data
		var rawData bson.M
		err = collection.FindOne(ctx, filterUpdate).Decode(&rawData)
		if err != nil {
			if err == mongo.ErrNoDocuments {
				t.Fatal("Survey not found")
			} else {
				t.Fatal("Error fetching survey:", err)
			}
		}

		// Unmarshal into your Survey struct
		new_survey := &domain.Survey{}
		bytes, err := bson.Marshal(rawData)
		if err != nil {
			t.Fatal("Failed to marshal raw data:", err)
		}
		new_survey.UnmarshalBSON(bytes)

		// Check the struct
		fmt.Printf("Survey Struct: %+v\n", new_survey)
	})
}
