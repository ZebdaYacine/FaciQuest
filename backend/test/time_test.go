package test

import (
	// "back-end/internal/domain"

	util "back-end/util/tools"
	"fmt"
	"testing"
)

func TestTime(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		timestemp := util.DateToTimeStemps("2024-09-28")
		fmt.Println(timestemp)
		fmt.Println(util.TimeStempsToDate(timestemp))
	})
}
