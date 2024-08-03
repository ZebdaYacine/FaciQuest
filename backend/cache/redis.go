package cache

import (
	"back-end/core"
	"context"
	"fmt"
	"log"
	"time"

	redis "github.com/go-redis/redis/v8"
)

// Function to check the Redis connection
func CheckRedisConnection() (*redis.Client, error) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     core.RediServer.REDIS_HOST, // Redis server address
		Password: "",                         // No password set
		DB:       0,                          // Use default DB
	})
	pong, err := rdb.Ping(context.Background()).Result()
	if err != nil {
		log.Print()
		return nil, fmt.Errorf("could not connect to Redis: %v", err)
	}
	fmt.Printf("Redis connected: %s\n", pong)
	return rdb, nil
}

func AddKey(rdb *redis.Client, key string, value string, expiration time.Duration) error {
	// Set a key-value pair in Redis
	return rdb.Set(context.Background(), key, value, expiration).Err()
}

func GetKey(rdb *redis.Client, key string) (string, error) {
	val, err := rdb.Get(context.Background(), key).Result()
	if err == redis.Nil {
		return "", nil
	} else if err != nil {
		return "", fmt.Errorf("could not get key: %v", err)
	}
	return val, nil
}
