package util

import (
	"fmt"
	"time"
)

func TimeStempsToDate(unixTimestampMilliSec int64) string {
	// Convert timestamp to time.Time
	date := time.UnixMilli(unixTimestampMilliSec)
	formattedDate := date.Format("2006-01-02")
	return formattedDate
}

func DateToTimeStemps(dStr string) int64 {
	layout := "2006-01-02"
	dstr, err := time.Parse(layout, dStr)
	if err != nil {
		fmt.Println("Error parsing date:", err)
	} else {
		fmt.Println("Parsed Date:", dstr)
	}
	unixTimestampMilliSec := dstr.UnixMilli()
	return unixTimestampMilliSec
}
