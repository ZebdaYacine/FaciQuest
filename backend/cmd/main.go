// package main

// import (
// 	"context"
// 	"fmt"
// 	"log"

// 	"go.mongodb.org/mongo-driver/bson"
// 	"go.mongodb.org/mongo-driver/mongo"
// 	"go.mongodb.org/mongo-driver/mongo/options"
// )

// type QuestionType interface {
// 	GetType() string
// }

// type Survey struct {
// 	ID        string         `bson:"_id"`
// 	Questions []QuestionType `bson:"questions"`
// }

// type StarRatingQuestion struct {
// 	BaseQuestion string `bson:"base_question"`
// 	MaxRating    int    `bson:"max_rating"`
// 	TypeQuestion string `bson:"type"`
// }

// func (q StarRatingQuestion) GetType() string {
// 	return "Star Rating"
// }

// type MultipleChoiceQuestion struct {
// 	BaseQuestion string   `bson:"base_question"`
// 	Choices      []string `bson:"choices"`
// 	TypeQuestion string   `bson:"type"`
// }

// func (q MultipleChoiceQuestion) GetType() string {
// 	return "Multiple Choice"
// }

// // Custom unmarshalling logic to convert BSON to concrete types
// func (s *Survey) UnmarshalBSON(data []byte) error {
// 	type Alias Survey
// 	aux := &struct {
// 		Questions []bson.Raw `bson:"questions"`
// 		*Alias
// 	}{
// 		Alias: (*Alias)(s),
// 	}

// 	if err := bson.Unmarshal(data, &aux); err != nil {
// 		return err
// 	}

// 	for _, rawQuestion := range aux.Questions {
// 		var questionMap map[string]interface{}
// 		if err := bson.Unmarshal(rawQuestion, &questionMap); err != nil {
// 			return err
// 		}

// 		questionType, ok := questionMap["type"].(string)
// 		if !ok {
// 			return fmt.Errorf("missing or invalid type field")
// 		}

// 		var qType QuestionType

// 		switch questionType {
// 		case "Star Rating":
// 			var starQuestion StarRatingQuestion
// 			if err := bson.Unmarshal(rawQuestion, &starQuestion); err != nil {
// 				return err
// 			}
// 			qType = starQuestion
// 		case "Multiple Choice":
// 			var mcQuestion MultipleChoiceQuestion
// 			if err := bson.Unmarshal(rawQuestion, &mcQuestion); err != nil {
// 				return err
// 			}
// 			qType = mcQuestion
// 		default:
// 			return fmt.Errorf("unknown question type: %s", questionType)
// 		}

// 		s.Questions = append(s.Questions, qType)
// 	}

// 	return nil
// }

// func readSurveyFromDB(collection *mongo.Collection, surveyID string) (*Survey, error) {
// 	var survey Survey
// 	filter := bson.M{"_id": surveyID}
// 	err := collection.FindOne(context.TODO(), filter).Decode(&survey)
// 	if err != nil {
// 		return nil, err
// 	}

// 	return &survey, nil
// }

// func main() {
// 	clientOptions := options.Client().ApplyURI("mongodb+srv://root:root@db.wkzekin.mongodb.net/?retryWrites=true&w=majority&appName=db")
// 	client, err := mongo.Connect(context.TODO(), clientOptions)
// 	if err != nil {
// 		log.Fatal(err)
// 	}

// 	defer func() {
// 		if err = client.Disconnect(context.TODO()); err != nil {
// 			log.Fatal(err)
// 		}
// 	}()

// 	collection := client.Database("FaciQuest").Collection("surveys")

// 	survey1 := Survey{
// 		ID: "1234",
// 		Questions: []QuestionType{
// 			StarRatingQuestion{
// 				BaseQuestion: "Rate the product ====================",
// 				MaxRating:    5,
// 				TypeQuestion: "Star Rating",
// 			},
// 			MultipleChoiceQuestion{
// 				BaseQuestion: "Choose your favorite color",
// 				Choices:      []string{"Red", "Green", "Blue"},
// 				TypeQuestion: "Multiple Choice",
// 			},
// 		},
// 	}

// 	result, err := collection.InsertOne(context.TODO(), survey1)
// 	if err != nil {
// 		log.Fatal(err)
// 	}

// 	fmt.Println("Inserted document with ID:", result.InsertedID)

// 	surveyID := "1234"

// 	survey, err := readSurveyFromDB(collection, surveyID)
// 	if err != nil {
// 		log.Fatal("Failed to read survey:", err)
// 	}

//		fmt.Printf("Survey ID: %s\n", survey.ID)
//		for _, q := range survey.Questions {
//			switch q.GetType() {
//			case "Star Rating":
//				starQuestion := q.(StarRatingQuestion) // Non-pointer assertion
//				fmt.Printf("Base Question: %s, Max Rating: %d\n", starQuestion.BaseQuestion, starQuestion.MaxRating)
//			case "Multiple Choice":
//				mcQuestion := q.(MultipleChoiceQuestion) // Non-pointer assertion
//				fmt.Printf("Base Question: %s, Choices: %v\n", mcQuestion.BaseQuestion, mcQuestion.Choices)
//			}
//			fmt.Printf("Question Type: %s\n", q.GetType())
//		}
//	}
package main

import (
	"back-end/api/server"
	"back-end/cache"
	common "back-end/core"
	"back-end/pkg/database"
	"log"
)

func main() {
	redis, err := cache.CheckRedisConnection()
	if err != nil {
		panic(err)
	}
	// cache.AddKey(rdb, "sed", "opfsdpofdsf", 100*time.Second)
	db := database.ConnectionDb()
	server.InitGinServer(db, redis)
	log.Printf("STRINGING SERVER %s", common.RootServer.SECRET_KEY)
}
