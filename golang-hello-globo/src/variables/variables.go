package variables

import (
	"os"
)

var Variables map[string]string

func GetVariables() {
	varMap := make(map[string]string)
	port := os.Getenv("PORT")
	redisHost := os.Getenv("REDIS_HOST")
	host := os.Getenv("HOST")
	debug := os.Getenv("DEBUG")

	if port == "" {
		port = "8000"
	}

	if host == "" {
		host = "0.0.0.0"
	}

	varMap["port"] = port
	varMap["redisHost"] = redisHost
	varMap["host"] = host
	varMap["debug"] = debug

	Variables = varMap
}