package test

import (
	"back-end/pkg/database/mongo"
	"testing"

	"github.com/stretchr/testify/assert"
)

// import (
// 	"back-end/internal/domain"
// 	"back-end/internal/repository"
// 	"back-end/pkg/database/oracle"
// 	"context"
// 	"fmt"
// 	"log"
// 	"testing"

// 	"github.com/stretchr/testify/assert"
// )

func TestMongoDBConnection(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		db, err := mongo.ConnectMongo()
		err1 := mongo.CreateUser(db)
		assert.NoError(t, err1)
		assert.NoError(t, err)
	})
}
