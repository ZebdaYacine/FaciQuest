package domain

import (
	"encoding/json"
	"fmt"
)

type QuestionType interface {
	GetType() string
}

type Survey struct {
	ID          string         `json:"id" bson:"_id"`
	UserId      string         `json:"userId"`
	Title       string         `json:"name"`
	Description string         `json:"description" bson:"description,omitempty"`
	Status      string         `json:"status"`
	Languages   []string       `json:"languages"`
	Topics      []string       `json:"topics"`
	LikertScale string         `json:"likertScale"`
	Questions   []QuestionType `json:"questions"`
	Sample      Sample         `json:"sample"`
}

type Sample struct {
	Size     int      `json:"size"`
	Type     string   `json:"type"`
	Location Location `json:"location"`
}

type Location struct {
	Country string   `json:"country" bson:"country"`
	State   []string `json:"state,omitempty" bson:"state,omitempty"`
	City    []string `json:"city,omitempty" bson:"city,omitempty"`
}

type BaseQuestion struct {
	Title string `json:"title"`
	Order int    `json:"order"`
}

type StarRatingQuestion struct {
	BaseQuestion
	MaxRating int    `json:"maxRating"`
	Shape     string `json:"shape"`
	Color     string `json:"color"`
}

func (q StarRatingQuestion) GetType() string {
	return "Star Rating"
}

type MultipleChoiceQuestion struct {
	BaseQuestion
	Choices []string `json:"choices"`
}

func (q MultipleChoiceQuestion) GetType() string {
	return "Multiple Choice"
}

type ImageChoiceQuestion struct {
	BaseQuestion
	Choices     []ImageDetail `json:"choices"`
	UseCheckbox bool          `json:"useCheckbox"`
}

func (q ImageChoiceQuestion) GetType() string {
	return "Image Choice"
}

type CheckboxesQuestion struct {
	BaseQuestion
	Choices []string `json:"choices"`
}

func (q CheckboxesQuestion) GetType() string {
	return "Checkboxes"
}

type DropdownQuestion struct {
	BaseQuestion
	Choices []string `json:"choices"`
}

func (q DropdownQuestion) GetType() string {
	return "Dropdown"
}

type MatrixQuestion struct {
	BaseQuestion
	Rows        []string `json:"rows"`
	Cols        []string `json:"cols"`
	UseCheckbox bool     `json:"useCheckbox"`
}

func (q MatrixQuestion) GetType() string {
	return "Matrix"
}

type FileUploadQuestion struct {
	BaseQuestion
	Instructions string   `json:"instructions,omitempty"`
	AllowedExts  []string `json:"allowedExtensions"`
}

func (q FileUploadQuestion) GetType() string {
	return "File Upload"
}

type ShortAnswerQuestion struct {
	BaseQuestion
	MaxLength int `json:"maxLength"`
}

func (q ShortAnswerQuestion) GetType() string {
	return "Short Answer"
}

type CommentBoxQuestion struct {
	BaseQuestion
	MaxLength int `json:"maxLength"`
	MaxLines  int `json:"maxLines"`
}

func (q CommentBoxQuestion) GetType() string {
	return "Comment Box"
}

type SliderQuestion struct {
	BaseQuestion
	Min int `json:"min"`
	Max int `json:"max"`
}

func (q SliderQuestion) GetType() string {
	return "Slider"
}

type DateTimeQuestion struct {
	BaseQuestion
	CollectDate bool `json:"collectDateInfo"`
	CollectTime bool `json:"collectTimeInfo"`
}

func (q DateTimeQuestion) GetType() string {
	return "Date / Time"
}

type NameQuestion struct {
	BaseQuestion
	FirstNameLabel  string  `json:"firstNameLabel"`
	LastNameLabel   string  `json:"lastNameLabel"`
	FirstNameHint   *string `json:"firstNameHint,omitempty"`
	LastNameHint    *string `json:"lastNameHint,omitempty"`
	MiddleNameLabel *string `json:"middleNameLabel,omitempty"`
	MiddleNameHint  *string `json:"middleNameHint,omitempty"`
	ShowFirstName   bool    `json:"showFirstName"`
	ShowLastName    bool    `json:"showLastName"`
	ShowMiddleName  bool    `json:"showMiddleName"`
}

func (q NameQuestion) GetType() string {
	return "Name"
}

type ImageQuestion struct {
	BaseQuestion
	Image ImageDetail `json:"image"`
}

func (q ImageQuestion) GetType() string {
	return "Image"
}

type ImageDetail struct {
	Caption *string `json:"caption,omitempty"`
	AltText *string `json:"altText,omitempty"`
	URL     *string `json:"url,omitempty"`
}

func (s *Survey) UnmarshalJSON(data []byte) error {
	type Alias Survey
	aux := &struct {
		Questions json.RawMessage `json:"questions"`
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
		questionType := q["type"].(string)
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
