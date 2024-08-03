package repository

import (
	"back-end/core"
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

type UserRepository interface {
	//AUTH FUNCTIONS
	Login(c context.Context, data *domain.LoginModel) (*domain.User, error)
	// Logout(c context.Context) error
	SignUp(c context.Context, data *domain.SignupModel) (*domain.User, error)
	IsAlreadyExist(c context.Context, data *domain.SignupModel) (bool, error)
	//SETTING PROFILE FUNCTIONS
	GetUserByEmail(c context.Context, email string) (*domain.User, error)
	SetNewPassword(c context.Context, data *domain.User) (*domain.User, error)
	UpdateProfile(c context.Context, data *domain.User) (*domain.User, error)
}

type userRepository struct {
	database database.Database
}

func NewUserRepository(db database.Database) UserRepository {
	return &userRepository{
		database: db,
	}
}

func getUser(data any, collection database.Collection, c context.Context) (*domain.User, error) {
	var resulat bson.M
	log.Print(data)
	err := collection.FindOne(c, data).Decode(&resulat)
	if err != nil {
		log.Print(err)
		return nil, err
	}
	id := resulat["_id"].(primitive.ObjectID).Hex()
	Role := resulat["role"].(string)
	User.ID = id
	User.Username = resulat["username"].(string)
	User.FirstName = resulat["firstname"].(string)
	User.LastName = resulat["lastname"].(string)
	User.Phone = resulat["phone"].(string)
	User.Role = Role
	return User, nil
}

// UpdateProfile implements domain.UserRepository.
func (ar *userRepository) UpdateProfile(c context.Context, data *domain.User) (*domain.User, error) {
	log.Println("LAUNCHE UPDATE PROFILE REPOSITORY")
	collection := ar.database.Collection("users")
	filterUpdate := bson.D{{Key: "email", Value: data.Email}}
	update := bson.M{
		"$set": bson.M{
			"firstname":    data.FirstName,
			"lastname":     data.LastName,
			"phone":        data.Phone,
			"birthDate":    data.Birthdate,
			"age":          data.Age,
			"birthPlace":   data.BirthPlace,
			"country":      data.Country,
			"municipal":    data.Municipal,
			"education":    data.Education,
			"workerAt":     data.WorkerAt,
			"institution":  data.Institution,
			"socialStatus": data.SocialStatus,
			"imageUrl":     data.ImageUrl,
			"bdd":          data.BDD,
		},
	}
	log.Println(filterUpdate)
	log.Println(update)
	return core.UpdateDoc[domain.User](c, collection, update, filterUpdate)
}

// IsAlreadyExist implements domain.UserRepository.
func (ar *userRepository) IsAlreadyExist(c context.Context, data *domain.SignupModel) (bool, error) {
	collection := ar.database.Collection("users")
	var resulat bson.M
	filter := bson.D{{Key: "email", Value: data.Email}}
	err := collection.FindOne(c, filter).Decode(&resulat)
	if err != mongo.ErrNoDocuments {
		return true, fmt.Errorf("user already exist")
	}
	return false, nil
}

// SetPassword implements domain.UserRepository.
func (ar *userRepository) SetNewPassword(c context.Context, data *domain.User) (*domain.User, error) {
	collection := ar.database.Collection("users")
	filterUpdate := bson.D{{Key: "email", Value: data.Email}}
	update := bson.M{
		"$set": bson.M{
			"password": data.PassWord,
		},
	}
	return core.UpdateDoc[domain.User](c, collection, update, filterUpdate)
}

// SignUp implements domain.AccountRepository.
func (ar *userRepository) SignUp(c context.Context, data *domain.SignupModel) (*domain.User, error) {
	collection := ar.database.Collection("users")
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
func (ar *userRepository) GetUserByEmail(c context.Context, email string) (*domain.User, error) {
	collection := ar.database.Collection("users")
	// Define the filter
	filter := bson.D{{Key: "email", Value: email}}
	user, err := getUser(filter, collection, c)
	if err != nil {
		log.Print(err)
		return nil, err
	}
	user.Email = email
	return User, nil
}

// Login implements domain.AccountRepository.
func (ar *userRepository) Login(c context.Context, data *domain.LoginModel) (*domain.User, error) {
	log.Println("LAUNCHE LOGIN REPOSITORY")
	collection := ar.database.Collection("users")
	// Define the filter
	filter := bson.D{{Key: "email", Value: data.Email}, {Key: "password", Value: data.Password}}
	log.Println(data)
	user, err := getUser(filter, collection, c)
	if err != nil {
		log.Print(err)
		return nil, err
	}
	user.Email = data.Email
	return user, nil
}
