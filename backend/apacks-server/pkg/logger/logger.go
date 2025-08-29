package logger

import (
	"os"

	"github.com/sirupsen/logrus"
)

type Logger struct {
	*logrus.Logger
}

func New() *Logger {
	logger := logrus.New()

	// Set output to stdout
	logger.SetOutput(os.Stdout)

	// Set log level
	logger.SetLevel(logrus.InfoLevel)

	// Set formatter
	logger.SetFormatter(&logrus.JSONFormatter{
		TimestampFormat: "2006-01-02 15:04:05",
	})

	return &Logger{logger}
}

func (l *Logger) Info(message string, args ...interface{}) {
	l.Logger.Infof(message, args...)
}

func (l *Logger) Error(message string, err error) {
	l.Logger.WithError(err).Error(message)
}

func (l *Logger) Fatal(message string, err error) {
	l.Logger.WithError(err).Fatal(message)
}

func (l *Logger) Debug(message string, args ...interface{}) {
	l.Logger.Debugf(message, args...)
}

func (l *Logger) Warn(message string, args ...interface{}) {
	l.Logger.Warnf(message, args...)
}
