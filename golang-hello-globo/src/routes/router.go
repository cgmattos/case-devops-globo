package routes

import (
	"github.com/labstack/echo/v4"
)

func InitRoutes(e *echo.Echo) {
	e.GET("/hello", GetHello)
	e.GET("/time", GetDatetime)
}