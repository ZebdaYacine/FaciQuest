package domain

import (
	"encoding/json"
	"fmt"
)

type QuestionType interface {
	GetType() string
}

type Survey struct {
	ID          string         `json:"_id"`
	UserId      string         `json:"userId" bson:"userId"`
	Title       string         `json:"name" bson:"name"`
	Description string         `json:"description" bson:"description,omitempty"`
	Status      string         `json:"status" bson:"status"`
	Languages   []string       `json:"languages" bson:"languages"`
	Topics      []string       `json:"topics" bson:"topics"`
	LikertScale string         `json:"likertScale" bson:"likertScale"`
	Questions   []QuestionType `json:"questions" bson:"questions"`
	Sample      Sample         `json:"sample" bson:"sample"`
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

type BaseQuestion struct {
	Title string `json:"title" bson:"title"`
	Order int    `json:"order" bson:"order"`
}

type StarRatingQuestion struct {
	BaseQuestion
	MaxRating int    `json:"maxRating" bson:"maxRating"`
	Shape     string `json:"shape" bson:"shape"`
	Color     string `json:"color" bson:"color"`
}

func (q StarRatingQuestion) GetType() string {
	return "Star Rating"
}

type MultipleChoiceQuestion struct {
	BaseQuestion
	Choices []string `json:"choices" bson:"choices"`
}

func (q MultipleChoiceQuestion) GetType() string {
	return "Multiple Choice"
}

type ImageChoiceQuestion struct {
	BaseQuestion
	Choices     []ImageDetail `json:"choices" bson:"choices"`
	UseCheckbox bool          `json:"useCheckbox" bson:"useCheckbox"`
}

func (q ImageChoiceQuestion) GetType() string {
	return "Image Choice"
}

type CheckboxesQuestion struct {
	BaseQuestion
	Choices []string `json:"choices" bson:"choices"`
}

func (q CheckboxesQuestion) GetType() string {
	return "Checkboxes"
}

type DropdownQuestion struct {
	BaseQuestion
	Choices []string `json:"choices" bson:"choices"`
}

func (q DropdownQuestion) GetType() string {
	return "Dropdown"
}

type MatrixQuestion struct {
	BaseQuestion
	Rows        []string `json:"rows" bson:"rows"`
	Cols        []string `json:"cols" bson:"cols"`
	UseCheckbox bool     `json:"useCheckbox" bson:"useCheckbox"`
}

func (q MatrixQuestion) GetType() string {
	return "Matrix"
}

type FileUploadQuestion struct {
	BaseQuestion
	Instructions string   `json:"instructions,omitempty" bson:"instructions,omitempty"`
	AllowedExts  []string `json:"allowedExtensions" bson:"allowedExtensions"`
}

func (q FileUploadQuestion) GetType() string {
	return "File Upload"
}

type ShortAnswerQuestion struct {
	BaseQuestion
	MaxLength int `json:"maxLength" bson:"maxLength"`
}

func (q ShortAnswerQuestion) GetType() string {
	return "Short Answer"
}

type CommentBoxQuestion struct {
	BaseQuestion
	MaxLength int `json:"maxLength" bson:"maxLength"`
	MaxLines  int `json:"maxLines" bson:"maxLines"`
}

func (q CommentBoxQuestion) GetType() string {
	return "Comment Box"
}

type SliderQuestion struct {
	BaseQuestion
	Min int `json:"min" bson:"min"`
	Max int `json:"max" bson:"max"`
}

func (q SliderQuestion) GetType() string {
	return "Slider"
}

type DateTimeQuestion struct {
	BaseQuestion
	CollectDate bool `json:"collectDateInfo" bson:"collectDateInfo"`
	CollectTime bool `json:"collectTimeInfo" bson:"collectTimeInfo"`
}

func (q DateTimeQuestion) GetType() string {
	return "Date / Time"
}

type NameQuestion struct {
	BaseQuestion
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
	BaseQuestion
	Image ImageDetail `json:"image" bson:"image"`
}

func (q ImageQuestion) GetType() string {
	return "Image"
}

type ImageDetail struct {
	Caption *string `json:"caption,omitempty" bson:"caption,omitempty"`
	AltText *string `json:"altText,omitempty" bson:"altText,omitempty"`
	URL     *string `json:"url,omitempty" bson:"url,omitempty"`
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
