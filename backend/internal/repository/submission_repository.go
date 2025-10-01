package repository

import (
	"back-end/core"
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"

	"go.mongodb.org/mongo-driver/bson"
)

type submissionRepository struct {
	database database.Database
}

type SubmissionRepository interface {
	CreateNewSubmission(c context.Context, submission *domain.Submission) (*domain.Submission, error)
	GetAnswers(c context.Context, surveyId string) (*[]domain.Answer, error)
	GetSurveyIDsByUserID(ctx context.Context, userID string) ([]string, error)
}

func NewSubmissionRepository(db database.Database) SubmissionRepository {
	return &submissionRepository{
		database: db,
	}
}

func (s *submissionRepository) GetSurveyIDsByUserID(ctx context.Context, userID string) ([]string, error) {
	collection := s.database.Collection("submission")

	results, err := collection.Distinct(ctx, "surveyId", bson.M{"userId": userID})
	if err != nil {
		return nil, fmt.Errorf("failed to get survey IDs: %w", err)
	}

	surveyIDs := make([]string, len(results))
	for i, v := range results {
		if idStr, ok := v.(string); ok {
			surveyIDs[i] = idStr
		}
	}

	return surveyIDs, nil
}

func (r *submissionRepository) CreateNewSubmission(c context.Context, submission *domain.Submission) (*domain.Submission, error) {
	collection := r.database.Collection(core.SUBMISSION)
	submission.Rewarded = 200.0
	_, err := collection.InsertOne(c, &submission)
	if err != nil {
		log.Printf("Failed to create submission: %v", err)
		return nil, err
	}
	repowalet := NewWalletRepository(r.database)
	wallet, _ := repowalet.GetWallet(c, core.WALLET, submission.UserId)
	if wallet == nil {
		wallet = &domain.Wallet{
			UserID:        submission.UserId,
			Amount:        0,
			NbrSurveys:    0,
			IsCashable:    false,
			CCP:           "",
			RIP:           "",
			PaymentMethod: "",
		}
	}
	wallet.Amount += float64(submission.Rewarded)
	wallet.NbrSurveys = wallet.NbrSurveys + 1
	_, err = repowalet.UpdateMyWallet(c, wallet)
	if err != nil {
		log.Printf("Failed to update wallet: %v", err)
		return nil, err
	}
	return submission, nil
}

func (r *submissionRepository) GetAnswers(c context.Context, surveyId string) (*[]domain.Answer, error) {
	collection := r.database.Collection(core.SUBMISSION)

	// Query filter for surveyId and collectorId
	filter := bson.M{
		"surveyId": surveyId,
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
