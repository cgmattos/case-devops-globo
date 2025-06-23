package server

import (
	_ "net/http"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

var Logger *echo.Logger

func Server() *echo.Echo{
	server := echo.New()
	server.Use(middleware.Logger())
	server.Use(middleware.Recover())

	Logger = &server.Logger

	return server
}