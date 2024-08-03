package test

import (
	// "back-end/internal/domain"

	util "back-end/util/tools"
	"fmt"
	"testing"
)

func TestTime(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		timestemp := util.DateToTimeStemps("1900-01-01")
		fmt.Println(timestemp)
		fmt.Println(util.TimeStempsToDate(timestemp))
	})
}
