package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	util "back-end/util/tools"
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type surveyRepository struct {
	database database.Database
}

const (
	APP_COMMISSION  = 1
	USER_COMMISSION = 1
)

type SurveyRepository interface {
	CreateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error)
	UpdateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error)
	DeleteSurvey(c context.Context, surveyId string, userId string) (bool, error)
	GetMySurveys(c context.Context, userId string) (*[]domain.SurveyBadge, error)
	GetSurveyById(c context.Context, surveyId string, userId string) (*domain.Survey, error)
	GetAllSurveys(c context.Context, userid string) (*[]domain.SurveyBadge, error)
	GetSurveysByStatus(c context.Context, status string) (*[]domain.SurveyBadge, error)
	GetAdminSurveys(c context.Context, status string, limit *int, offset *int, startAt *time.Time, endAt *time.Time) (*[]domain.SurveyBadge, error)
	UpdateSurveyStatus(c context.Context, surveyId string, status string) (bool, error)
}

func NewSurveyRepository(db database.Database) SurveyRepository {
	return &surveyRepository{
		database: db,
	}
}

// DeleteSurvey implements SurveyRepository.
func (s *surveyRepository) DeleteSurvey(c context.Context, surveyId string, userId string) (bool, error) {
	collection := s.database.Collection("survey")
	id, err := primitive.ObjectIDFromHex(surveyId)
	if err != nil {
		log.Fatal(err)
	}
	filter := bson.M{
		"_id":                id,
		"surveybadge.userId": userId,
	}
	result, err := collection.DeleteOne(c, &filter)
	if err != nil {
		log.Printf("Failed to delete survey: %v", err)
		return false, err
	}
	if result.DeletedCount == 0 {
		fmt.Println("No documents matched the filter")
		return false, nil
	}
	return true, nil
}

// GetSurveyById implements SurveyRepository.
func (s *surveyRepository) GetSurveyById(c context.Context, surveyId string, userId string) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	new_survey := &domain.Survey{}
	id, err := primitive.ObjectIDFromHex(surveyId)
	if err != nil {
		log.Fatal(err)
	}
	filter := bson.M{
		"_id": id,
		//"surveybadge.userId": userId,
	}
	err = collection.FindOne(c, filter).Decode(new_survey)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, fmt.Errorf("survey not found")
		}
		return nil, err
	}
	fmt.Println(new_survey)
	return new_survey, nil
}

// GetAllSurveys implements SurveyRepository.
// func (s *surveyRepository) GetAllSurveys(c context.Context, userid string) (*[]domain.SurveyBadge, error) {
// 	collection := s.database.Collection("survey")
// 	sr := NewSubmissionRepository(s.database)

// 	// Get surveys already answered by this user
// 	surveys, err := sr.GetSurveyIDsByUserID(c, userid)
// 	if err != nil {
// 		return nil, err
// 	}

// 	// Convert string IDs to ObjectIDs if needed
// 	var objectIDs []primitive.ObjectID
// 	for _, id := range surveys {
// 		objID, err := primitive.ObjectIDFromHex(id)
// 		if err == nil {
// 			objectIDs = append(objectIDs, objID)
// 		}
// 	}

// 	// Find surveys NOT in the answered list
// 	filter := bson.M{}
// 	if len(objectIDs) > 0 {
// 		filter = bson.M{"_id": bson.M{"$nin": objectIDs}}
// 	}

// 	list, err := collection.Find(c, filter)
// 	if err != nil {
// 		log.Printf("Failed to load surveys: %v", err)
// 		return nil, err
// 	}
// 	list_surveys := []domain.SurveyBadge{}
// 	for list.Next(c) {
// 		new_survey := domain.Survey{}
// 		if err := list.Decode(&new_survey); err != nil {
// 			log.Fatal(err)
// 		}
// 		new_survey.SurveyBadge.Price = float64(new_survey.CountQuestions) * APP_COMMISSION
// 		list_surveys = append(list_surveys, new_survey.SurveyBadge)
// 	}
// 	return &list_surveys, nil
// }

func (s *surveyRepository) GetAllSurveys(c context.Context, userid string) (*[]domain.SurveyBadge, error) {
	collection := s.database.Collection("survey")
	sr := NewSubmissionRepository(s.database)

	// Get surveys already answered by this user
	surveys, err := sr.GetSurveyIDsByUserID(c, userid)
	if err != nil {
		return nil, err
	}

	// Convert string IDs to ObjectIDs if needed
	var objectIDs []primitive.ObjectID
	for _, id := range surveys {
		objID, err := primitive.ObjectIDFromHex(id)
		if err == nil {
			objectIDs = append(objectIDs, objID)
		}
	}

	// Exclude surveys answered by user + surveys created by user
	filter := bson.M{
		"userId": bson.M{"$ne": userid}, // use userId field from SurveyBadge
	}
	if len(objectIDs) > 0 {
		filter["_id"] = bson.M{"$nin": objectIDs}
	}

	// Query surveys
	list, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load surveys: %v", err)
		return nil, err
	}

	list_surveys := []domain.SurveyBadge{}
	for list.Next(c) {
		new_survey := domain.Survey{}
		if err := list.Decode(&new_survey); err != nil {
			log.Fatal(err)
		}
		new_survey.SurveyBadge.Price = float64(new_survey.CountQuestions) * APP_COMMISSION
		list_surveys = append(list_surveys, new_survey.SurveyBadge)
	}

	return &list_surveys, nil
}

// GetMySurveys implements SurveyRepository.
func (s *surveyRepository) GetMySurveys(c context.Context, userId string) (*[]domain.SurveyBadge, error) {
	collection := s.database.Collection("survey")
	filter := bson.M{
		"surveybadge.userId": userId,
	}
	list, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load surveys: %v", err)
		return nil, err
	}
	list_surveys := []domain.SurveyBadge{}
	for list.Next(c) {
		new_survey := domain.Survey{}
		if err := list.Decode(&new_survey); err != nil {
			log.Fatal(err)
		}
		list_surveys = append(list_surveys, new_survey.SurveyBadge)
	}
	return &list_surveys, nil
}

func saveBase64Image(base64Str, folder, filenameWithoutExt string) (string, error) {
	dir := filepath.Join("/var/www/ftp", folder)
	if err := os.MkdirAll(dir, 0755); err != nil {
		return "", fmt.Errorf("failed to create directory: %v", err)
	}
	log.Println("Directory ensured:", dir)
	fileDir := filepath.Join(dir, filenameWithoutExt)
	filename, err := util.SaveBase64ToFile(base64Str, fileDir)
	if err != nil {
		return "", fmt.Errorf("failed to save image: %v", err)
	}
	url := "http://185.209.230.104/" + strings.TrimPrefix(*filename, "/var/www/ftp/")
	return url, nil
}

// CreateSurvey implements SurveyRepository.
func (s *surveyRepository) CreateSurvey(c context.Context, survey *domain.Survey) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	survey.CreatedAt = time.Now()
	survey.Status = "draft"

	for i, q := range survey.Questions {
		switch q.GetType() {
		case "Image Choice":
			imageChoiceQuestion, ok := q.(domain.ImageChoiceQuestion)
			if !ok {
				return nil, fmt.Errorf("invalid ImageChoiceQuestion type assertion at index %d", i)
			}

			for j := range imageChoiceQuestion.Choices {
				img := imageChoiceQuestion.Choices[j].Image
				if img != nil && *img != "" {
					log.Printf("Processing image choice %d-%d, Base64 size: %d", i, j, len(*img))
					filename := fmt.Sprintf("%d%d", i+1, j+1)
					url, err := saveBase64Image(*img, survey.Name, filename)
					if err != nil {
						return nil, fmt.Errorf("failed to save image: %v", err)
					}
					imageChoiceQuestion.Choices[j].URL = &url
					imageChoiceQuestion.Choices[j].Image = new(string)
				}
			}
			survey.Questions[i] = imageChoiceQuestion

		case "Image":
			imageQuestion, ok := q.(domain.ImageQuestion)
			if !ok {
				return nil, fmt.Errorf("invalid ImageQuestion type assertion at index %d", i)
			}

			if imageQuestion.Image.Image != nil && *imageQuestion.Image.Image != "" {
				log.Printf("Processing image question %d, Base64 size: %d", i, len(*imageQuestion.Image.Image))

				filename := fmt.Sprintf("%d", i+1)
				url, err := saveBase64Image(*imageQuestion.Image.Image, survey.Name, filename)
				if err != nil {
					return nil, fmt.Errorf("failed to save image: %v", err)
				}

				log.Println("Saved image URL:", url)
				imageQuestion.Image.URL = &url
				imageQuestion.Image.Image = new(string) // clear Base64
			}
			survey.Questions[i] = imageQuestion
		}
	}

	res, err := collection.InsertOne(c, survey)
	if err != nil {
		log.Printf("Failed to create survey: %v", err)
		return nil, err
	}

	surveyId := res.(string)
	survey.ID = surveyId

	_, err = s.UpdateSurvey(c, survey)
	if err != nil {
		return nil, err
	}

	return survey, nil
}

// UpdateSurvey implements SurveyRepository.
func (s *surveyRepository) UpdateSurvey(c context.Context, updatedSurvey *domain.Survey) (*domain.Survey, error) {
	collection := s.database.Collection("survey")
	id, err := primitive.ObjectIDFromHex(updatedSurvey.ID)
	if err != nil {
		log.Fatal(err)
	}
	updatedSurvey.UpdatedAt = time.Now()
	// filterUpdate := bson.D{{Key: "_id", Value: id}}
	filterUpdate := bson.M{
		"_id":                id,
		"surveybadge.userId": updatedSurvey.SurveyBadge.UserId,
	}
	update := bson.M{
		"$set": updatedSurvey,
	}

	for i, q := range updatedSurvey.Questions {
		switch q.GetType() {
		case "Image Choice":
			imageChoiceQuestion, ok := q.(domain.ImageChoiceQuestion)
			if !ok {
				return nil, fmt.Errorf("invalid ImageChoiceQuestion type assertion at index %d", i)
			}

			for j := range imageChoiceQuestion.Choices {
				img := imageChoiceQuestion.Choices[j].Image
				if img != nil && *img != "" {
					log.Printf("Processing image choice %d-%d, Base64 size: %d", i, j, len(*img))
					filename := fmt.Sprintf("%d%d", i+1, j+1)
					log.Println("Image:", &img)
					url, err := saveBase64Image(*img, updatedSurvey.Name, filename)
					if err != nil {
						return nil, fmt.Errorf("failed to save image: %v", err)
					}
					imageChoiceQuestion.Choices[j].URL = &url
					imageChoiceQuestion.Choices[j].Image = new(string)
				}
			}
			updatedSurvey.Questions[i] = imageChoiceQuestion

		case "Image":
			imageQuestion, ok := q.(domain.ImageQuestion)
			if !ok {
				return nil, fmt.Errorf("invalid ImageQuestion type assertion at index %d", i)
			}

			if imageQuestion.Image.Image != nil && *imageQuestion.Image.Image != "" {
				log.Printf("Processing image question %d, Base64 size: %d", i, len(*imageQuestion.Image.Image))

				filename := fmt.Sprintf("%d", i+1)
				url, err := saveBase64Image(*imageQuestion.Image.Image, updatedSurvey.Name, filename)
				if err != nil {
					return nil, fmt.Errorf("failed to save image: %v", err)
				}

				log.Println("Saved image URL:", url)
				imageQuestion.Image.URL = &url
				imageQuestion.Image.Image = new(string) // clear Base64
			}
			updatedSurvey.Questions[i] = imageQuestion
		}
	}

	_, err = collection.UpdateOne(c, filterUpdate, update)
	if err != nil {
		return nil, fmt.Errorf("operation not allowed")
	}
	new_survey := &domain.Survey{}
	err = collection.FindOne(c, filterUpdate).Decode(new_survey)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, fmt.Errorf("survey not found")
		}
		return nil, err
	}
	return new_survey, nil
}

// GetSurveysByStatus implements SurveyRepository.
func (s *surveyRepository) GetSurveysByStatus(c context.Context, status string) (*[]domain.SurveyBadge, error) {
	collection := s.database.Collection("survey")
	filter := bson.M{}
	if status != "" {
		filter = bson.M{
			"surveybadge.status": status,
		}
	}
	list, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load surveys by status: %v", err)
		return nil, err
	}
	list_surveys := []domain.SurveyBadge{}
	for list.Next(c) {
		new_survey := domain.Survey{}
		if err := list.Decode(&new_survey); err != nil {
			log.Fatal(err)
		}
		list_surveys = append(list_surveys, new_survey.SurveyBadge)
	}
	return &list_surveys, nil
}

func (s *surveyRepository) GetAdminSurveys(c context.Context, status string, limit *int, offset *int, startAt *time.Time, endAt *time.Time) (*[]domain.SurveyBadge, error) {
	collection := s.database.Collection("survey")
	filter := bson.M{}
	and := []bson.M{}
	if status != "" {
		and = append(and, bson.M{"surveybadge.status": status})
	}
	if startAt != nil {
		and = append(and, bson.M{"surveybadge.createdAt": bson.M{"$gte": *startAt}})
	}
	if endAt != nil {
		and = append(and, bson.M{"surveybadge.createdAt": bson.M{"$lte": *endAt}})
	}
	if len(and) > 0 {
		filter = bson.M{"$and": and}
	}

	cursor, err := collection.Find(c, filter)
	if err != nil {
		log.Printf("Failed to load admin surveys: %v", err)
		return nil, err
	}
	var all []domain.SurveyBadge
	for cursor.Next(c) {
		var doc domain.Survey
		if err := cursor.Decode(&doc); err != nil {
			return nil, err
		}
		all = append(all, doc.SurveyBadge)
	}
	_ = cursor.Close(c)

	l := 50
	o := 0
	if limit != nil && *limit > 0 {
		l = *limit
	}
	if offset != nil && *offset >= 0 {
		o = *offset
	}
	if o > len(all) {
		return &[]domain.SurveyBadge{}, nil
	}
	end := o + l
	if end > len(all) {
		end = len(all)
	}
	paged := all[o:end]
	return &paged, nil
}

func (s *surveyRepository) UpdateSurveyStatus(c context.Context, surveyId string, status string) (bool, error) {
	collection := s.database.Collection("survey")
	id, err := primitive.ObjectIDFromHex(surveyId)
	if err != nil {
		return false, fmt.Errorf("invalid surveyId")
	}
	update := bson.M{
		"$set": bson.M{
			"surveybadge.status":    status,
			"surveybadge.updatedAt": time.Now(),
		},
	}
	res, err := collection.UpdateOne(c, bson.M{"_id": id}, update)
	if err != nil {
		return false, err
	}
	return res.ModifiedCount > 0, nil
}
