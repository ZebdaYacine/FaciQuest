package test

import (
	"back-end/util"
	"testing"

	"github.com/stretchr/testify/assert"
)

// import (
// 	"back-end/internal/domain"
// 	"back-end/internal/repository"
// 	"back-end/pkg/database/oracle"
// 	"context"
// 	"fmt"
// 	"log"
// 	"testing"

// 	"github.com/stretchr/testify/assert"
// )

func TestSendingEmail(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		str, err := util.GenerateDigit()
		util.SendEmail("zebdaadam1996@gmail.com", "Confirm regestration", str)
		assert.NoError(t, err)
	})
}
