package api

import (
	"fmt"

	"github.com/smelserm/apacks/backend/internal/config"
	"github.com/smelserm/apacks/backend/internal/handlers"
	"github.com/smelserm/apacks/backend/internal/middleware"
	"github.com/smelserm/apacks/backend/pkg/logger"

	"github.com/gin-gonic/gin"
)

type Server struct {
	router *gin.Engine
	config *config.Config
	logger *logger.Logger
}

func NewServer(cfg *config.Config, log *logger.Logger) *Server {
	router := gin.Default()

	// Add middleware
	router.Use(middleware.CORS())
	router.Use(middleware.Logger(log))
	router.Use(middleware.Recovery(log))

	server := &Server{
		router: router,
		config: cfg,
		logger: log,
	}

	server.setupRoutes()
	return server
}

func (s *Server) setupRoutes() {
	// Health check
	s.router.GET("/health", handlers.HealthCheck)

	// API v1 routes
	v1 := s.router.Group("/api/v1")
	{
		// Public routes
		v1.GET("/ping", handlers.Ping)

		// Protected routes
		protected := v1.Group("/")
		protected.Use(middleware.Auth(s.config.JWT.Secret))
		{
			// Add your protected routes here
			protected.GET("/user", handlers.GetUser)
		}
	}
}

func (s *Server) Start() error {
	addr := fmt.Sprintf("%s:%s", s.config.Server.Host, s.config.Server.Port)
	return s.router.Run(addr)
}
