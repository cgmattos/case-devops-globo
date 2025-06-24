package routes

import (
	"fmt"
	"net/http"
	"time"

	"github.com/cgmattos/case-devops-globo/src/cache"
	"github.com/cgmattos/case-devops-globo/src/server"
	"github.com/cgmattos/case-devops-globo/src/variables"
	"github.com/labstack/echo/v4"
)

func GetDatetime(c echo.Context) error {
	var datetime string
	if cache.Connected {
		data, err := cache.GetValueFromCache(variables.EnvVars.CacheKey)
		if err != nil {
			data = fmt.Sprint(time.Now().Format("02-01-2006 15:04:05"))
			cache.PutValueOnCache(variables.EnvVars.CacheKey, data)
		}
		datetime = data
	} else {
		server.Logger.Info("Redis not connected, skiping cache")
		datetime = fmt.Sprint(time.Now().Format("02-01-2006 15:04:05"))
	}
	
	return c.JSON(http.StatusOK, map[string]string{"language": "Go", "time": datetime})
}