package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"

	"go.mongodb.org/mongo-driver/bson"
)

type surveyRepository struct {
	database database.Database
}

type SurveyRepository interface {
	CreateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error)
	UpdateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error)
}

func NewSurveyRepository(db database.Database) SurveyRepository {
	return &surveyRepository{
		database: db,
	}
}

// CreateSurvey implements SurveyRepository.
func (s *surveyRepository) CreateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	resulat, err := collection.InsertOne(c, &survey)
	if err != nil {
		log.Printf("Failed to create survey: %v", err)
		return nil, err
	}
	surveyId := resulat.(string)
	survey.ID = surveyId
	return survey, nil
}

// UpdateSurvey implements SurveyRepository.
func (s *surveyRepository) UpdateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error) {
	log.Println(survey)
	collection := s.database.Collection("survey")
	filterUpdate := bson.D{{Key: "_id", Value: survey.ID}}
	update := bson.M{
		"$set": bson.M{
			"userId":      survey.UserId,
			"name":        survey.Title,
			"description": survey.Description,
			"status":      survey.Status,
			"languages":   survey.Languages,
			"topics":      survey.Topics,
			"likertScale": survey.LikertScale,
			"questions":   convertQuestionsToConcrete(survey.Questions),
			"sample":      survey.Sample,
		},
	}

	_, err := collection.UpdateOne(c, filterUpdate, update)
	if err != nil {
		log.Panic(err)
		return nil, err
	}
	return survey, nil

}

func convertQuestionsToConcrete(questions []domain.QuestionType) []interface{} {
	var result []interface{}
	for _, question := range questions {
		switch q := question.(type) {
		case domain.StarRatingQuestion:
			result = append(result, q)
		case domain.MultipleChoiceQuestion:
			result = append(result, q)
		case domain.ImageChoiceQuestion:
			result = append(result, q)
		case domain.CheckboxesQuestion:
			result = append(result, q)
		case domain.DropdownQuestion:
			result = append(result, q)
		case domain.MatrixQuestion:
			result = append(result, q)
		case domain.FileUploadQuestion:
			result = append(result, q)
		case domain.ShortAnswerQuestion:
			result = append(result, q)
		case domain.CommentBoxQuestion:
			result = append(result, q)
		case domain.SliderQuestion:
			result = append(result, q)
		case domain.DateTimeQuestion:
			result = append(result, q)
		case domain.NameQuestion:
			result = append(result, q)
		case domain.ImageQuestion:
			result = append(result, q)
		default:
			// Handle unknown types or log an error
			fmt.Printf("Warning: unknown question type: %+v\n", q)
		}
	}
	return result
}
