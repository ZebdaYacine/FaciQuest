package util

import (
	"fmt"
	"time"
)

// Define a custom time type
type CustomTime struct {
	time.Time
}

// Define the custom date-time format
const customTimeFormat = "2006-01-02 15:04:05.0000000"

// UnmarshalJSON for CustomTime
func (ct *CustomTime) UnmarshalJSON(b []byte) error {
	// Remove the quotes around the string
	str := string(b)
	str = str[1 : len(str)-1]
	// Parse the time string according to the custom format
	t, err := time.Parse(customTimeFormat, str)
	if err != nil {
		return err
	}
	// Set the time
	ct.Time = t
	return nil
}

// MarshalJSON for CustomTime
func (ct CustomTime) MarshalJSON() ([]byte, error) {
	// Format the time according to the custom format
	return []byte(fmt.Sprintf("\"%s\"", ct.Format(customTimeFormat))), nil
}
