package test

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"
	"testing"

	"github.com/stretchr/testify/assert"
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
		id, err := primitive.ObjectIDFromHex("66fd50e3494ea58f2044e718")
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

func TestDeleteSurveyRepository(t *testing.T) {
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
		//id, err := primitive.ObjectIDFromHex("66fd50e3494ea58f2044e718")
		// Filter by userId
		userId := "66ced91b015ced6ece935ed4"
		filter := bson.M{
			"surveybadge.userId": userId,
		}
		collection := db.Collection("survey")

		// Find all surveys that match the filter
		cursor, err := collection.Find(ctx, filter)
		if err != nil {
			log.Fatal(err)
		}
		defer cursor.Close(ctx)

		fmt.Println(cursor.Next(ctx))
		var surveys []domain.Survey
		for cursor.Next(ctx) {
			var survey domain.Survey
			if err := cursor.Decode(&survey); err != nil {
				log.Fatal(err)
			}
			surveys = append(surveys, survey)
		}

		// Print all found surveys
		for _, survey := range surveys {
			fmt.Printf("Survey ID: %s \n", survey.SurveyBadge.ID)
		}

	})
}

func TestGetMySurvey(t *testing.T) {
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
		survey := &domain.Survey{}
		survey.UserId = "66ced91b015ced6ece935ed4"
		// survey.ID = "66fd50e3494ea58f2044e718"
		sr := repository.NewSurveyRepository(db)
		record, err := sr.GetMySurveys(ctx, survey.UserId)
		for _, survey := range *record {
			fmt.Printf("survey ID: %s\n", survey.ID)
		}
		assert.NoError(t, err)
	})
}
