package util

import (
	"encoding/json"
	"log"
)

func ObjectToJson(object any) ([]byte, error) {
	jsonData, err := json.Marshal(&object)
	if err != nil {
		log.Fatalf("Error marshaling struct: %v", err)
		return nil, err
	}
	return jsonData, nil
}

func JsonToObject(jsonData []byte, objectFromJSON any) (any, error) {
	err := json.Unmarshal(jsonData, &objectFromJSON)
	if err != nil {
		log.Fatalf("Error unmarshaling JSON: %v", err)
		return objectFromJSON, nil
	}
	return objectFromJSON, nil
}
