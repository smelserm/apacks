package middleware

import (
	"errors"
	"net/http"

    "apacks/pkg/logger"
	"github.com/gin-gonic/gin"
)

// CORS middleware for handling Cross-Origin Resource Sharing
func CORS() gin.HandlerFunc {
	return gin.HandlerFunc(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "http://localhost:3000")
		c.Header("Access-Control-Allow-Credentials", "true")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Header("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	})
}

// Logger middleware for request logging
func Logger(log *logger.Logger) gin.HandlerFunc {
	return gin.LoggerWithFormatter(func(param gin.LogFormatterParams) string {
		log.Info("Request processed",
			"method", param.Method,
			"path", param.Path,
			"status", param.StatusCode,
			"latency", param.Latency,
			"client_ip", param.ClientIP,
		)
		return ""
	})
}

// Recovery middleware for panic recovery
func Recovery(log *logger.Logger) gin.HandlerFunc {
	return gin.CustomRecovery(func(c *gin.Context, recovered interface{}) {
		if errStr, ok := recovered.(string); ok {
			err := errors.New(errStr)
			log.Error("Panic recovered", err)
		}
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"error": "Internal server error",
		})
	})
}

// Auth middleware for JWT authentication
func Auth(jwtSecret string) gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.GetHeader("Authorization")
		if token == "" {
			c.JSON(http.StatusUnauthorized, gin.H{
				"error": "Authorization header required",
			})
			c.Abort()
			return
		}

		// Remove "Bearer " prefix if present
		if len(token) > 7 && token[:7] == "Bearer " {
			token = token[7:]
		}

		// TODO: Implement JWT validation
		// For now, just set a mock user_id
		c.Set("user_id", "mock-user-id")
		c.Next()
	}
}
