package routes

import (
	"net/http"
	"github.com/labstack/echo/v4"
	"fmt"
	"time"
)

func GetDatetime(c echo.Context) error {
	datetime := fmt.Sprint(time.Now().Format("02-01-2006 15:04:05"))
	return c.JSON(http.StatusOK, map[string]string{"language": "Go", "time": datetime})
}