package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
)

type AnswersParams struct {
	SurveyID    string
	CollectorID string
}

type AnswersResulat struct {
	Data *[]domain.Answer
	Err  error
}

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
	GetAnswers(c context.Context, params *AnswersParams) *AnswersResulat
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

func (sub *submissionUseCase) GetAnswers(c context.Context, params *AnswersParams) *AnswersResulat {
	result, err := sub.repo.GetAnswers(c, params.SurveyID, params.CollectorID)
	if err != nil {
		return &AnswersResulat{Err: err}
	}
	return &AnswersResulat{Data: result, Err: nil}
}
