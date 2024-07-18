package mongo

import (
	"back-end/pkg"
	"back-end/pkg/database"
	"context"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

var db_opt = pkg.GET_DB_SERVER_SEETING()

type mongoClient struct {
	cl *mongo.Client
}
type mongoDatabase struct {
	db *mongo.Database
}
type mongoCollection struct {
	coll *mongo.Collection
}

func NewClient(connection string) (database.Client, error) {
	c, err := mongo.NewClient(options.Client().ApplyURI(connection))
	if err != nil {
		return nil, err
	}
	return &mongoClient{cl: c}, nil
}

func (mc *mongoClient) Ping(ctx context.Context) error {
	return mc.cl.Ping(ctx, readpref.Primary())
}

func (mc *mongoClient) Database(dbName string) database.Database {
	db := mc.cl.Database(dbName)
	return &mongoDatabase{db: db}
}

func (mc *mongoClient) Connect(ctx context.Context) error {
	return mc.cl.Connect(ctx)
}

func (mc *mongoClient) Disconnect(ctx context.Context) error {
	return mc.cl.Disconnect(ctx)
}

func (md *mongoDatabase) Collection(colName string) database.Collection {
	collection := md.db.Collection(colName)
	return &mongoCollection{coll: collection}
}

func (md *mongoDatabase) Client() database.Client {
	client := md.db.Client()
	return &mongoClient{cl: client}
}

func (mc *mongoCollection) InsertOne(ctx context.Context, document interface{}) (interface{}, error) {
	id, err := mc.coll.InsertOne(ctx, document)
	objectID := id.InsertedID.(primitive.ObjectID)
	return objectID.Hex(), err
}

func ConnectionDb() database.Database {
	client, err := NewClient(db_opt.SERVER_ADDRESS_DB)
	if err != nil {
		log.Fatalf("Failed to create MongoDB client: %v", err)
	}
	// Create a context with a timeout
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	// Connect to the MongoDB server
	if err := client.Connect(ctx); err != nil {
		log.Fatalf("Failed to connect to MongoDB: %v", err)
	}
	// Get the database and collection
	log.Print("_________________________CONNECT TO DATABASE_________________________")
	return client.Database(db_opt.DB_NAME)
}
