package repository

import (
	"back-end/core"
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"log"

	"go.mongodb.org/mongo-driver/bson"
)

type submissionRepository struct {
	database database.Database
}

type SubmissionRepository interface {
	CreateNewSubmission(c context.Context, submission *domain.Submission) (*domain.Submission, error)
	GetAnswers(c context.Context, surveyId string, collcollectorId string) (*[]domain.Answer, error)
}

func NewSubmissionRepository(db database.Database) SubmissionRepository {
	return &submissionRepository{
		database: db,
	}
}

func (r *submissionRepository) CreateNewSubmission(c context.Context, submission *domain.Submission) (*domain.Submission, error) {
	collection := r.database.Collection(core.SUBMISSION)
	_, err := collection.InsertOne(c, &submission)
	if err != nil {
		log.Printf("Failed to create submission: %v", err)
		return nil, err
	}
	return submission, nil
}

func (r *submissionRepository) GetAnswers(c context.Context, surveyId string, collectorId string) (*[]domain.Answer, error) {
	collection := r.database.Collection(core.SUBMISSION)

	// Query filter for surveyId and collectorId
	filter := bson.M{
		"surveyId":    surveyId,
		"collectorId": collectorId,
	}

	// Find documents matching the filter
	cursor, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load answers: %v", err)
		return nil, err
	}
	defer cursor.Close(c)

	var answers []domain.Answer
	for cursor.Next(c) {
		var submission domain.Submission
		if err := cursor.Decode(&submission); err != nil {
			log.Printf("Failed to decode submission: %v", err)
			return nil, err
		}
		answers = append(answers, submission.Answers...)
	}
	if err := cursor.Err(); err != nil {
		log.Printf("Cursor iteration error: %v", err)
		return nil, err
	}
	log.Printf("Retrieved answers: %v", answers)
	return &answers, nil
}
