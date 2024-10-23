package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
)

type SubmissionParams struct {
	Data *domain.Submission
}

type SubmissionResulat struct {
	Data *domain.Submission
	Err  error
}

type submissionUseCase struct {
	repo       repository.SubmissionRepository
	collection string
}

type SubmissionUseCase interface {
	CreateNewSubmission(c context.Context, params *SubmissionParams) *SubmissionResulat
}

func NewSubmissionUseCase(repo repository.SubmissionRepository, collection string) SubmissionUseCase {
	return &submissionUseCase{
		repo:       repo,
		collection: collection,
	}
}

func (sub *submissionUseCase) CreateNewSubmission(c context.Context, params *SubmissionParams) *SubmissionResulat {
	result, err := sub.repo.CreateNewSubmission(c, params.Data)
	if err != nil {
		return &SubmissionResulat{Err: err}
	}
	return &SubmissionResulat{Data: result, Err: nil}
}
