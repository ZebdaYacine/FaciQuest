package domain

type Survey struct {
	Title               string        `json:"title" bson:"title"`                                                 // Required
	Description         string        `json:"description,omitempty" bson:"description,omitempty"`                 // Optional
	GeneralInformation  []Information `json:"information,omitempty" bson:"information,omitempty"`                 // Optional
	Language            string        `json:"language" bson:"language"`                                           // Required
	AdditionalLanguages []string      `json:"additionalLanguages,omitempty" bson:"additionalLanguages,omitempty"` // Optional
	LikertScale         string        `json:"likertScale" bson:"likertScale"`                                     // Required
	Questions           []Question    `json:"questions" bson:"questions"`                                         // Required
	Translations        []Translation `json:"translations,omitempty" bson:"translations,omitempty"`               // Optional
	Sample              Sample        `json:"sample" bson:"sample"`
	UserId              string        `bson:"userid"` // Required
}

type Information struct {
	Name  string `json:"name" bson:"name"`   // Required if present
	Value string `json:"value" bson:"value"` // Required if present
}

type Question struct {
	Text         string   `json:"text" bson:"text"`                               // Required
	ResponseType string   `json:"responseType" bson:"responseType"`               // Required
	FileTypes    []string `json:"fileTypes,omitempty" bson:"fileTypes,omitempty"` // Optional
	Image        string   `json:"image,omitempty" bson:"image,omitempty"`         // Optional
	Order        int      `json:"order,omitempty" bson:"order,omitempty"`         // Optional
}

type Translation struct {
	TranslatedText map[string]string `json:"translatedText" bson:"translatedText"` // Optional
}

type Sample struct {
	Type     string   `json:"type" bson:"type"`         // Required
	Size     int      `json:"size" bson:"size"`         // Required
	Location Location `json:"location" bson:"location"` // Required
}

type Location struct {
	Country string   `json:"country" bson:"country"`                 // Required
	State   []string `json:"state,omitempty" bson:"state,omitempty"` // Optional
	City    []string `json:"city,omitempty" bson:"city,omitempty"`   // Optional
}
