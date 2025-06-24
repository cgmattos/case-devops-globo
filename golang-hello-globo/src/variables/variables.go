package variables

import (
	"os"
	"strconv"
	"strings"
)

var EnvVars EnvironmentVariables

type EnvironmentVariables struct {
	Port string
	Debug bool
	Host string
	RedisUrl string
	RedisPassword string
	RedisDB int
	CacheKey string
	CacheTimeout int

}

func InitVariables() {
	redisUrl := os.Getenv("REDIS_URL")
	redisPassword := os.Getenv("REDIS_PASSWORD")
	redisDB, err := strconv.Atoi(os.Getenv("REDIS_DB"))
	if err != nil {
		redisDB = 0
	}
	cacheKey := os.Getenv("CACHE_KEY")
	cacheTimeout, err := strconv.Atoi(os.Getenv("CACHE_TIMEOUT"))
	if err != nil {
		cacheTimeout = 10
	}
	port := os.Getenv("PORT")
	host := os.Getenv("HOST")
	debug := false
	debugStr := strings.ToLower(os.Getenv("DEBUG"))
	if debugStr == "true"{
		debug = true
	}

	EnvVars = EnvironmentVariables{
		RedisUrl: redisUrl,
		RedisPassword: redisPassword,
		RedisDB: redisDB,
		CacheKey: cacheKey,
		CacheTimeout: cacheTimeout,
		Port: port,
		Debug: debug,
		Host: host,
	}
}