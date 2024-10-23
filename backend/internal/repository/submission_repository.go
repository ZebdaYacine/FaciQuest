package repository

import (
	"back-end/core"
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"log"
)

type submissionRepository struct {
	database database.Database
}

type SubmissionRepository interface {
	CreateNewSubmission(c context.Context, submission *domain.Submission) (*domain.Submission, error)
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
