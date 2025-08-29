package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// HealthCheck handles health check requests
func HealthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status":  "ok",
		"message": "Server is running",
	})
}

// Ping handles ping requests
func Ping(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "pong",
	})
}

// GetUser handles user retrieval requests
func GetUser(c *gin.Context) {
	// Extract user from context (set by auth middleware)
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": "User not authenticated",
		})
		return
	}

	// Return more detailed user information
	c.JSON(http.StatusOK, gin.H{
		"user_id":    userID,
		"message":    "User retrieved successfully",
		"email":      "user@example.com",
		"first_name": "John",
		"last_name":  "Doe",
		"created_at": "2024-01-01T00:00:00Z",
		"updated_at": "2024-01-01T00:00:00Z",
	})
}
