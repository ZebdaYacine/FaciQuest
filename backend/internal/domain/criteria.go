package domain

import (
	"errors"
	"fmt"
)

type Criteria struct {
	ID          string    `json:"id" bson:"id"`
	Title       string    `json:"title" bson:"title"`
	Description string    `json:"description" bson:"description"`
	Choices     []Choices `json:"choices" bson:"choices"`
	Category    Category  `json:"category" bson:"category"`
}

type Category struct {
	ID   string `json:"id" bson:"id"`
	Name string `json:"Name" bson:"Name"`
}

type Choices struct {
	ID    string `json:"id" bson:"id"`
	Title string `json:"title" bson:"title"`
}

func (c *Criteria) Validate() error {

	if c.Title == "" {
		return errors.New("criteria Title cannot be empty")
	}
	if len(c.Choices) == 0 {
		return errors.New("criteria must have at least one choice")
	}
	if err := c.Category.Validate(); err != nil {
		return fmt.Errorf("invalid category: %w", err)
	}

	return nil
}

func (cat *Category) Validate() error {
	if cat.Name == "" {
		return errors.New("category Name cannot be empty")
	}
	return nil
}
