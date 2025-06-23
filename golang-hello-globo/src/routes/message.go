package routes

import (
	"net/http"
	"github.com/labstack/echo/v4"
)

func GetHello(c echo.Context) error {
	return c.JSON(http.StatusOK, map[string]string{"language": "Go", "message": "Olá, Globo!"})
}