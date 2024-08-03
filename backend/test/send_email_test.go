package test

import (
	"back-end/util/email"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestSendingEmail(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		str, err := email.GenerateDigit()
		email.SendEmail("zebdaadam1996@gmail.com", "Confirm regestration", str)
		assert.NoError(t, err)
	})
}
