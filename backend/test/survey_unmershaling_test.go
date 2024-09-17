package test

import (
	"back-end/internal/domain"
	"encoding/json"
	"fmt"
	"testing"
)

func TestSurveyUnmershling(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		surveyJSON := `
	{
		"id": "survey123",
		"userId": "user456",
		"name": "Customer Satisfaction Survey",
		"description": "A survey to assess customer satisfaction",
		"status": "active",
		"languages": ["en", "fr"],
		"topics": ["service", "quality"],
		"likertScale": "5-point",
		"questions": [
			{
				"type": "Star Rating",
				"title": "Rate our service",
				"order": 1,
				"maxRating": 5,
				"shape": "star",
				"color": "yellow"
			},
			{
				"type": "Multiple Choice",
				"title": "Which product do you like?",
				"order": 2,
				"choices": ["Product A", "Product B", "Product C"]
			},
			{
				"type": "Image Choice",
				"title": "Choose a product image",
				"order": 3,
				"choices": [
					{
						"caption": "Product A",
						"altText": "Image of Product A",
						"url": "https://example.com/product-a.jpg"
					},
					{
						"caption": "Product B",
						"altText": "Image of Product B",
						"url": "https://example.com/product-b.jpg"
					}
				],
				"useCheckbox": false
			}
		],
		"sample": {
			"size": 100,
			"type": "random",
			"location": {
				"country": "USA",
				"state": ["California"],
				"city": ["San Francisco"]
			}
		}
	}`

		var survey domain.Survey
		err := json.Unmarshal([]byte(surveyJSON), &survey)
		if err != nil {
			fmt.Println("Error unmarshaling:", err)
			return
		}

		fmt.Printf("Unmarshaled Survey: %+v\n", survey)
	})
}
