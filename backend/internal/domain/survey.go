package domain

import (
	"encoding/json"
	"fmt"
	"time"

	"go.mongodb.org/mongo-driver/bson"
)

type QuestionType interface {
	GetType() string
}

type SurveyBadge struct {
	ID             string    `json:"_id" bson:"id"`
	UserId         string    `json:"userId" bson:"userId"`
	Name           string    `json:"name" bson:"name"`
	Description    string    `json:"description,omitempty" bson:"description,omitempty"`
	Status         string    `json:"status" bson:"status"`
	Languages      []string  `json:"languages" bson:"languages"`
	Topics         []string  `json:"topics" bson:"topics"`
	Views          int       `json:"views" bson:"views"`
	CountQuestions int       `json:"countQuestions" bson:"countQuestions"`
	CountAnswers   int       `json:"countAnswers" bson:"countAnswers"`
	CreatedAt      time.Time `bson:"createdAt"`
	UpdatedAt      time.Time `bson:"updatedAt"`
}

type Survey struct {
	SurveyBadge
	LikertScale string         `json:"likertScale" bson:"likertScale"`
	Questions   []QuestionType `json:"questions" bson:"questions"`
	Sample      Sample         `json:"sample,omitempty" bson:"sample,omitempty"`
}

type Sample struct {
	Size     int      `json:"size" bson:"size"`
	Type     string   `json:"type" bson:"type"`
	Location Location `json:"location" bson:"location"`
}

type Location struct {
	Country string   `json:"country" bson:"country"`
	State   []string `json:"state,omitempty" bson:"state,omitempty"`
	City    []string `json:"city,omitempty" bson:"city,omitempty"`
}

// type BaseQuestion struct {
// 	ID           string `json:"id" bson:"id"`
// 	Title        string `json:"title" bson:"title"`
// 	Order        int    `json:"order" bson:"order"`
// 	TypeQuestion string `json:"type" bson:"type"`
// 	IsRequired   bool   `json:"isrequired" bson:"isrequired"`
// }

type StarRatingQuestion struct {
	ID           string `json:"id" bson:"id"`
	Title        string `json:"title" bson:"title"`
	Order        int    `json:"order" bson:"order"`
	TypeQuestion string `json:"type" bson:"type"`
	IsRequired   bool   `json:"isrequired" bson:"isrequired"`
	MaxRating    int    `json:"maxRating" bson:"maxRating"`
	Shape        string `json:"shape" bson:"shape"`
	Color        string `json:"color" bson:"color"`
}

func (q StarRatingQuestion) GetType() string {
	return "Star Rating"
}

type MultipleChoiceQuestion struct {
	ID           string   `json:"id" bson:"id"`
	Title        string   `json:"title" bson:"title"`
	Order        int      `json:"order" bson:"order"`
	TypeQuestion string   `json:"type" bson:"type"`
	IsRequired   bool     `json:"isrequired" bson:"isrequired"`
	Choices      []string `json:"choices" bson:"choices"`
}

func (q MultipleChoiceQuestion) GetType() string {
	return "Multiple Choice"
}

type ImageChoiceQuestion struct {
	ID           string        `json:"id" bson:"id"`
	Title        string        `json:"title" bson:"title"`
	Order        int           `json:"order" bson:"order"`
	TypeQuestion string        `json:"type" bson:"type"`
	IsRequired   bool          `json:"isrequired" bson:"isrequired"`
	Choices      []ImageDetail `json:"choices" bson:"choices"`
	UseCheckbox  bool          `json:"useCheckbox" bson:"useCheckbox"`
}

func (q ImageChoiceQuestion) GetType() string {
	return "Image Choice"
}

type CheckboxesQuestion struct {
	ID           string   `json:"id" bson:"id"`
	Title        string   `json:"title" bson:"title"`
	Order        int      `json:"order" bson:"order"`
	TypeQuestion string   `json:"type" bson:"type"`
	IsRequired   bool     `json:"isrequired" bson:"isrequired"`
	Choices      []string `json:"choices" bson:"choices"`
}

func (q CheckboxesQuestion) GetType() string {
	return "Checkboxes"
}

type DropdownQuestion struct {
	ID           string   `json:"id" bson:"id"`
	Title        string   `json:"title" bson:"title"`
	Order        int      `json:"order" bson:"order"`
	TypeQuestion string   `json:"type" bson:"type"`
	IsRequired   bool     `json:"isrequired" bson:"isrequired"`
	Choices      []string `json:"choices" bson:"choices"`
}

func (q DropdownQuestion) GetType() string {
	return "Dropdown"
}

type MatrixQuestion struct {
	ID           string   `json:"id" bson:"id"`
	Title        string   `json:"title" bson:"title"`
	Order        int      `json:"order" bson:"order"`
	TypeQuestion string   `json:"type" bson:"type"`
	IsRequired   bool     `json:"isrequired" bson:"isrequired"`
	Rows         []string `json:"rows" bson:"rows"`
	Cols         []string `json:"cols" bson:"cols"`
	UseCheckbox  bool     `json:"useCheckbox" bson:"useCheckbox"`
}

func (q MatrixQuestion) GetType() string {
	return "Matrix"
}

type FileUploadQuestion struct {
	ID           string   `json:"id" bson:"id"`
	Title        string   `json:"title" bson:"title"`
	Order        int      `json:"order" bson:"order"`
	TypeQuestion string   `json:"type" bson:"type"`
	IsRequired   bool     `json:"isrequired" bson:"isrequired"`
	Instructions string   `json:"instructions,omitempty" bson:"instructions,omitempty"`
	AllowedExts  []string `json:"allowedExtensions" bson:"allowedExtensions"`
}

func (q FileUploadQuestion) GetType() string {
	return "File Upload"
}

type ShortAnswerQuestion struct {
	ID           string `json:"id" bson:"id"`
	Title        string `json:"title" bson:"title"`
	Order        int    `json:"order" bson:"order"`
	TypeQuestion string `json:"type" bson:"type"`
	IsRequired   bool   `json:"isrequired" bson:"isrequired"`
	MaxLength    int    `json:"maxLength" bson:"maxLength"`
}

func (q ShortAnswerQuestion) GetType() string {
	return "Short Answer"
}

type CommentBoxQuestion struct {
	ID           string `json:"id" bson:"id"`
	Title        string `json:"title" bson:"title"`
	Order        int    `json:"order" bson:"order"`
	TypeQuestion string `json:"type" bson:"type"`
	IsRequired   bool   `json:"isrequired" bson:"isrequired"`
	MaxLength    int    `json:"maxLength" bson:"maxLength"`
	MaxLines     int    `json:"maxLines" bson:"maxLines"`
}

func (q CommentBoxQuestion) GetType() string {
	return "Comment Box"
}

type SliderQuestion struct {
	ID           string `json:"id" bson:"id"`
	Title        string `json:"title" bson:"title"`
	Order        int    `json:"order" bson:"order"`
	TypeQuestion string `json:"type" bson:"type"`
	IsRequired   bool   `json:"isrequired" bson:"isrequired"`
	Min          int    `json:"min" bson:"min"`
	Max          int    `json:"max" bson:"max"`
}

func (q SliderQuestion) GetType() string {
	return "Slider"
}

type DateTimeQuestion struct {
	ID           string `json:"id" bson:"id"`
	Title        string `json:"title" bson:"title"`
	Order        int    `json:"order" bson:"order"`
	TypeQuestion string `json:"type" bson:"type"`
	IsRequired   bool   `json:"isrequired" bson:"isrequired"`
	CollectDate  bool   `json:"collectDateInfo" bson:"collectDateInfo"`
	CollectTime  bool   `json:"collectTimeInfo" bson:"collectTimeInfo"`
}

func (q DateTimeQuestion) GetType() string {
	return "Date / Time"
}

type NameQuestion struct {
	ID              string  `json:"id" bson:"id"`
	Title           string  `json:"title" bson:"title"`
	Order           int     `json:"order" bson:"order"`
	TypeQuestion    string  `json:"type" bson:"type"`
	IsRequired      bool    `json:"isrequired" bson:"isrequired"`
	FirstNameLabel  string  `json:"firstNameLabel" bson:"firstNameLabel"`
	LastNameLabel   string  `json:"lastNameLabel" bson:"lastNameLabel"`
	FirstNameHint   *string `json:"firstNameHint,omitempty" bson:"firstNameHint,omitempty"`
	LastNameHint    *string `json:"lastNameHint,omitempty" bson:"lastNameHint,omitempty"`
	MiddleNameLabel *string `json:"middleNameLabel,omitempty" bson:"middleNameLabel,omitempty"`
	MiddleNameHint  *string `json:"middleNameHint,omitempty" bson:"middleNameHint,omitempty"`
	ShowFirstName   bool    `json:"showFirstName" bson:"showFirstName"`
	ShowLastName    bool    `json:"showLastName" bson:"showLastName"`
	ShowMiddleName  bool    `json:"showMiddleName" bson:"showMiddleName"`
}

func (q NameQuestion) GetType() string {
	return "Name"
}

type ImageQuestion struct {
	ID           string      `json:"id" bson:"id"`
	Title        string      `json:"title" bson:"title"`
	Order        int         `json:"order" bson:"order"`
	TypeQuestion string      `json:"type" bson:"type"`
	IsRequired   bool        `json:"isrequired" bson:"isrequired"`
	Image        ImageDetail `json:"image" bson:"image"`
}

func (q ImageQuestion) GetType() string {
	return "Image"
}

type ImageDetail struct {
	Caption *string `json:"caption,omitempty" bson:"caption,omitempty"`
	AltText *string `json:"altText,omitempty" bson:"altText,omitempty"`
	URL     *string `json:"url,omitempty" bson:"url,omitempty"`
}

func (s *Survey) QuestionToBSON(question QuestionType) (bson.M, error) {
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

func (s *Survey) UnmarshalJSON(data []byte) error {
	type Alias Survey
	aux := &struct {
		Questions json.RawMessage `json:"questions" bson:"questions"`
		*Alias
	}{
		Alias: (*Alias)(s),
	}

	if err := json.Unmarshal(data, &aux); err != nil {
		return err
	}

	var questions []map[string]interface{}
	if err := json.Unmarshal(aux.Questions, &questions); err != nil {
		return err
	}

	for _, q := range questions {
		questionType, ok := q["type"].(string)
		if !ok {
			return fmt.Errorf("type field is missing or not a string")
		}

		var qType QuestionType

		switch questionType {
		case "Star Rating":
			var starQuestion StarRatingQuestion
			if err := mapToStruct(q, &starQuestion); err != nil {
				return err
			}
			qType = starQuestion
		case "Multiple Choice":
			var mcQuestion MultipleChoiceQuestion
			if err := mapToStruct(q, &mcQuestion); err != nil {
				return err
			}
			qType = mcQuestion
		case "Image Choice":
			var imgQuestion ImageChoiceQuestion
			if err := mapToStruct(q, &imgQuestion); err != nil {
				return err
			}
			qType = imgQuestion
		case "Checkboxes":
			var checkboxQuestion CheckboxesQuestion
			if err := mapToStruct(q, &checkboxQuestion); err != nil {
				return err
			}
			qType = checkboxQuestion
		case "Dropdown":
			var dropdownQuestion DropdownQuestion
			if err := mapToStruct(q, &dropdownQuestion); err != nil {
				return err
			}
			qType = dropdownQuestion
		case "Matrix":
			var matrixQuestion MatrixQuestion
			if err := mapToStruct(q, &matrixQuestion); err != nil {
				return err
			}
			qType = matrixQuestion
		case "File Upload":
			var fileUploadQuestion FileUploadQuestion
			if err := mapToStruct(q, &fileUploadQuestion); err != nil {
				return err
			}
			qType = fileUploadQuestion
		case "Short Answer":
			var shortAnswerQuestion ShortAnswerQuestion
			if err := mapToStruct(q, &shortAnswerQuestion); err != nil {
				return err
			}
			qType = shortAnswerQuestion
		case "Comment Box":
			var commentBoxQuestion CommentBoxQuestion
			if err := mapToStruct(q, &commentBoxQuestion); err != nil {
				return err
			}
			qType = commentBoxQuestion
		case "Slider":
			var sliderQuestion SliderQuestion
			if err := mapToStruct(q, &sliderQuestion); err != nil {
				return err
			}
			qType = sliderQuestion
		case "Date / Time":
			var dateTimeQuestion DateTimeQuestion
			if err := mapToStruct(q, &dateTimeQuestion); err != nil {
				return err
			}
			qType = dateTimeQuestion
		case "Name":
			var nameQuestion NameQuestion
			if err := mapToStruct(q, &nameQuestion); err != nil {
				return err
			}
			qType = nameQuestion
		case "Image":
			var imageQuestion ImageQuestion
			if err := mapToStruct(q, &imageQuestion); err != nil {
				return err
			}
			qType = imageQuestion
		default:
			return fmt.Errorf("unknown question type: %s", questionType)
		}

		s.Questions = append(s.Questions, qType)
	}

	return nil
}

func mapToStruct(m map[string]interface{}, result interface{}) error {
	data, err := json.Marshal(m)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, result)
}

// Custom unmarshalling logic to convert BSON to concrete types
func (s *Survey) UnmarshalBSON(data []byte) error {
	type Alias Survey
	aux := &struct {
		LikertScale string     `bson:"likertScale"`
		Sample      Sample     `bson:"sample"`
		Questions   []bson.Raw `bson:"questions"`
		SurveyBadge
		*Alias
	}{
		Alias: (*Alias)(s),
	}

	if err := bson.Unmarshal(data, aux); err != nil {
		return err
	}

	s.SurveyBadge = aux.SurveyBadge
	s.LikertScale = aux.LikertScale
	s.Sample = aux.Sample

	for _, rawQuestion := range aux.Questions {
		var questionMap map[string]interface{}
		if err := bson.Unmarshal(rawQuestion, &questionMap); err != nil {
			return err
		}

		questionType, ok := questionMap["type"].(string)
		if !ok {
			return fmt.Errorf("missing or invalid type field")
		}

		var qType QuestionType

		// Switch based on the question type
		switch questionType {
		case "Star Rating":
			var starQuestion StarRatingQuestion
			if err := bson.Unmarshal(rawQuestion, &starQuestion); err != nil {
				return err
			}
			qType = starQuestion
		case "Multiple Choice":
			var mcQuestion MultipleChoiceQuestion
			if err := bson.Unmarshal(rawQuestion, &mcQuestion); err != nil {
				return err
			}
			qType = mcQuestion
		case "Image Choice":
			var imageChoiceQuestion ImageChoiceQuestion
			if err := bson.Unmarshal(rawQuestion, &imageChoiceQuestion); err != nil {
				return err
			}
			qType = imageChoiceQuestion
		case "Checkboxes":
			var checkboxesQuestion CheckboxesQuestion
			if err := bson.Unmarshal(rawQuestion, &checkboxesQuestion); err != nil {
				return err
			}
			qType = checkboxesQuestion
		case "Dropdown":
			var dropdownQuestion DropdownQuestion
			if err := bson.Unmarshal(rawQuestion, &dropdownQuestion); err != nil {
				return err
			}
			qType = dropdownQuestion
		case "Matrix":
			var matrixQuestion MatrixQuestion
			if err := bson.Unmarshal(rawQuestion, &matrixQuestion); err != nil {
				return err
			}
			qType = matrixQuestion
		case "File Upload":
			var fileUploadQuestion FileUploadQuestion
			if err := bson.Unmarshal(rawQuestion, &fileUploadQuestion); err != nil {
				return err
			}
			qType = fileUploadQuestion
		case "Short Answer":
			var shortAnswerQuestion ShortAnswerQuestion
			if err := bson.Unmarshal(rawQuestion, &shortAnswerQuestion); err != nil {
				return err
			}
			qType = shortAnswerQuestion
		case "Comment Box":
			var commentBoxQuestion CommentBoxQuestion
			if err := bson.Unmarshal(rawQuestion, &commentBoxQuestion); err != nil {
				return err
			}
			qType = commentBoxQuestion
		case "Slider":
			var sliderQuestion SliderQuestion
			if err := bson.Unmarshal(rawQuestion, &sliderQuestion); err != nil {
				return err
			}
			qType = sliderQuestion
		case "Date / Time":
			var dateTimeQuestion DateTimeQuestion
			if err := bson.Unmarshal(rawQuestion, &dateTimeQuestion); err != nil {
				return err
			}
			qType = dateTimeQuestion
		case "Name":
			var nameQuestion NameQuestion
			if err := bson.Unmarshal(rawQuestion, &nameQuestion); err != nil {
				return err
			}
			qType = nameQuestion
		case "Image":
			var imageQuestion ImageQuestion
			if err := bson.Unmarshal(rawQuestion, &imageQuestion); err != nil {
				return err
			}
			qType = imageQuestion
		default:
			return fmt.Errorf("unknown question type: %s", questionType)
		}
		s.Questions = append(s.Questions, qType)
	}
	return nil
}
