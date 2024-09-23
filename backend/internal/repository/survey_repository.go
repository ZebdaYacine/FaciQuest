package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"encoding/json"
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
func (s *surveyRepository) UpdateSurvey(c context.Context, updatedSurvey *domain.Survey) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	filterUpdate := bson.D{{Key: "_id", Value: updatedSurvey.ID}}
	update := bson.M{
		"$set": bson.M{
			"name":        updatedSurvey.Title,
			"description": updatedSurvey.Description,
			"status":      updatedSurvey.Status,
			"languages":   updatedSurvey.Languages,
			"topics":      updatedSurvey.Topics,
			"likertScale": updatedSurvey.LikertScale,
			//"questions":   convertQuestionsToConcrete(updatedSurvey.Questions),
			"sample": bson.M{
				"size":     updatedSurvey.Sample.Size,
				"type":     updatedSurvey.Sample.Type,
				"location": updatedSurvey.Sample.Location,
			},
		},
	}
	_, err := collection.UpdateOne(c, filterUpdate, update)
	if err != nil {
		log.Panic(err)
		return nil, err
	}
	// var new_survey *domain.Survey
	// filter := bson.M{"_id": survey.ID}
	// err = collection.FindOne(c, filter).Decode(new_survey)
	// if err != nil {
	// 	if err == mongo.ErrNoDocuments {
	// 		return nil, fmt.Errorf("survey not found")
	// 	}
	// 	return nil, err
	//}
	return updatedSurvey, nil
	// return core.UpdateDoc[domain.Survey](c, collection, update, filterUpdate)
}

func questionToBSON(question domain.QuestionType) (bson.M, error) {
	data, err := json.Marshal(question)
	if err != nil {
		return nil, err
	}

	var result bson.M
	if err := json.Unmarshal(data, &result); err != nil {
		return nil, err
	}

	return result, nil
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
			fmt.Printf("Warning: unknown question type: %+v\n", q)
		}
	}
	return result
}
