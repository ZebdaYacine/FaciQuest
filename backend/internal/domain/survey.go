package domain

import "back-end/core/entities"

type Survey struct {
	ID                  string                 `json:"_id"`
	Name                string                 `json:"name"`
	Description         string                 `json:"descriptions"`
	LikertScal          int                    `json:"likert_scal"`
	GeneralInformations []entities.Information `json:"informations"`
	QuestionItems       []string               `json:"question_items"`
	Link                string                 `json:"link"`
	OptionAnswer        string                 `json:"options_answer"`
}
