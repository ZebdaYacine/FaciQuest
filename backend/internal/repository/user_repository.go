package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

var (
	User = &domain.User{}
)

type userRepository struct {
	database database.Database
}

func NewUserRepository(db database.Database) domain.UserRepository {
	return &userRepository{
		database: db,
	}
}

func convertBsonToStruct[T domain.Account](bsonData primitive.M) (*T, error) {
	var model *T
	bsonBytes, err := bson.Marshal(bsonData)
	if err != nil {
		log.Panic("Error marshalling bson.M:", err)
		return nil, err
	}

	err = bson.Unmarshal(bsonBytes, &model)
	if err != nil {
		log.Panic("Error unmarshalling to struct:", err)
		return nil, err
	}
	return model, err
}

// RsetPassword implements domain.UserRepository.
func (ar *userRepository) RsetPassword(c context.Context, data *domain.RestPasswordModel) (*domain.User, error) {
	collection := ar.database.Collection("users")
	filterUpdate := bson.D{{Key: "email", Value: data.Email}}
	update := bson.M{
		"$set": bson.M{"password": data.NewPassword},
	}
	_, err := collection.UpdateOne(c, filterUpdate, update)
	if err != nil {
		log.Panic(err)
		return nil, fmt.Errorf("error was happend")
	}
	var updatedDocument bson.M
	err = collection.FindOne(c, filterUpdate).Decode(&updatedDocument)
	if err != nil {
		log.Panic("Error finding updated document:", err)
		return nil, fmt.Errorf("error was happend")
	}
	fmt.Print("Password is updated successfuly")
	updatedUser, err := convertBsonToStruct[domain.User](updatedDocument)
	if err != nil {
		log.Printf("Failed to convert bson to struct: %v", err)
		return nil, err
	}
	return updatedUser, nil
}

// SignUp implements domain.AccountRepository.
func (ar *userRepository) SignUp(c context.Context, data *domain.SignupModel) (*domain.User, error) {
	collection := ar.database.Collection("users")
	var resulat bson.M
	filter := bson.D{{Key: "email", Value: data.Email}}
	err := collection.FindOne(c, filter).Decode(&resulat)
	if err != mongo.ErrNoDocuments {
		return nil, fmt.Errorf("user already exist")
	}
	log.Println("No documents found matching the filter")
	data.Role = "User"
	userID, err1 := collection.InsertOne(c, data)
	if err1 != nil {
		log.Printf("Failed to insert user: %v", err1)
		return nil, err1
	}
	log.Printf("Create user agent with id %v", userID)
	User.ID = userID.(string)
	User.FirstName = data.FirstName
	User.LastName = data.LastName
	User.Phone = data.Phone
	User.Email = data.Email
	User.Role = data.Role
	return User, nil

}

// Login implements domain.AccountRepository.
func (ar *userRepository) Login(c context.Context, data *domain.LoginModel) (*domain.User, error) {
	collection := ar.database.Collection("users")
	var resulat bson.M
	err := collection.FindOne(c, data).Decode(&resulat)
	if err != nil {
		log.Print(err)
		return nil, err
	}
	id := resulat["_id"].(primitive.ObjectID).Hex()
	Role := resulat["role"].(string)
	User.ID = id
	User.Email = data.Email
	User.Username = data.UserName
	User.PassWord = data.Password
	User.Role = Role
	return User, nil
}

// GetRole implements domain.AccountRepository.
// func (ar *userRepository) GetRole(c context.Context, userId string) (string, error) {
// 	collection := ar.database.Collection("users")
// 	id, err := primitive.ObjectIDFromHex(userId)
// 	if err != nil {
// 		log.Print(err)
// 		return "", err
// 	}
// 	var result bson.M
// 	err1 := collection.FindOne(c, bson.M{"_id": id}).Decode(&result)
// 	if err1 != nil {
// 		log.Printf("Failed to find to user: %v", err)
// 		return "", err1
// 	}
// 	jsonBytes, err := json.Marshal(result["role_id"])
// 	if err != nil {
// 		log.Println(err)
// 		return "", err
// 	}
// 	return string(jsonBytes), nil
// }
