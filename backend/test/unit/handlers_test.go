package unit

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"apacks/internal/handlers"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func setupTestRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)
	router := gin.New()
	return router
}

func TestHealthCheck(t *testing.T) {
	router := setupTestRouter()
	router.GET("/health", handlers.HealthCheck)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/health", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "ok")
}

func TestPing(t *testing.T) {
	router := setupTestRouter()
	router.GET("/ping", handlers.Ping)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/ping", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "pong")
}

func TestGetUser_Unauthorized(t *testing.T) {
	router := setupTestRouter()
	router.GET("/user", handlers.GetUser)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/user", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusUnauthorized, w.Code)
}
