package cache

import (
	"context"
	"fmt"
	"time"

	"github.com/cgmattos/case-devops-globo/src/server"
	"github.com/cgmattos/case-devops-globo/src/variables"
	"github.com/redis/go-redis/v9"
)

var Connected bool

var RedisClient *redis.Client

func InitRedisClient() {
	rdb := redis.NewClient(&redis.Options{
		Addr:     variables.EnvVars.RedisUrl,
		Password: variables.EnvVars.RedisPassword,
		DB:       variables.EnvVars.RedisDB,
		PoolSize: 20,
		PoolTimeout: 5 * time.Second,
	})

	RedisClient = rdb
}

func pongRedis(ctx context.Context) {
	redisCtx, cancel := context.WithTimeout(ctx, 1*time.Second)
	defer cancel()

	pong, err := RedisClient.Ping(redisCtx).Result()
	if err != nil {
		server.Logger.Info("Coudn't ping redis. Connection is down")
		Connected = false
	}

	if pong == "PONG" {
		Connected = true
		server.Logger.Debug("Redis ping responded successfully")
	} else {
		server.Logger.Infof("Redis ping responded with %s", pong)
		Connected = false
	}
}

func CacheHealthCheck() {
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	ctx := context.Background()

	for range ticker.C {
		pongRedis(ctx)
	}
}

func GetValueFromCache(cacheKey string) (string, error) {
	ctx := context.Background()
	data, err := RedisClient.Get(ctx, cacheKey).Result()
	server.Logger.Debug(fmt.Sprint(data))
	if err != nil {
		server.Logger.Errorf("Coudn't get key %s: %s", cacheKey, err)
		return "", err
	}
	return data, nil
}

func PutValueOnCache(cacheKey string, data string) error {
	ctx := context.Background()
	err := RedisClient.SetEx(
		ctx,
		cacheKey,
		data,
		time.Duration(variables.EnvVars.CacheTimeout) * time.Second,
	).Err()
	if err != nil {
		server.Logger.Errorf("Coudn't save data on cache with key %s. Error: %s",
			cacheKey,
			err,
		)
		return err
	}
	server.Logger.Info("Cache Updated")
	return nil
}