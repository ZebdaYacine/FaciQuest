package test

import (
	"back-end/util/email"
	// "fmt"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestSendingEmail(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		pin, err := email.GenerateDigit()
		// emailBody := fmt.Sprintf(`
		// <h2>Password Reset Request</h2>
		// <p>Here is your reset token:</p>
		// <p><b>%s</b></p>
		// <p>And your verification PIN:</p>
		// <p><b>%s</b></p>
		// <p>Click 
		// <a href="https://yourfrontend.com/reset?token=%s">here</a> to reset your password.</p>
	    // `, "token", pin, "token")
		email.SendEmail("zebdaadam1996@gmail.com", "Confirm regestration", pin)
		assert.NoError(t, err)
	})
}
