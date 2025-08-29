package validator

import (
	"regexp"
	"strings"
)

// EmailValidator validates email format
func IsValidEmail(email string) bool {
	emailRegex := regexp.MustCompile(`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)
	return emailRegex.MatchString(email)
}

// PasswordValidator validates password strength
func IsValidPassword(password string) bool {
	if len(password) < 8 {
		return false
	}

	hasUpper := regexp.MustCompile(`[A-Z]`).MatchString(password)
	hasLower := regexp.MustCompile(`[a-z]`).MatchString(password)
	hasNumber := regexp.MustCompile(`[0-9]`).MatchString(password)

	return hasUpper && hasLower && hasNumber
}

// StringValidator validates string length
func IsValidStringLength(str string, min, max int) bool {
	length := len(strings.TrimSpace(str))
	return length >= min && length <= max
}

// RequiredValidator checks if a string is not empty
func IsRequired(str string) bool {
	return strings.TrimSpace(str) != ""
}
