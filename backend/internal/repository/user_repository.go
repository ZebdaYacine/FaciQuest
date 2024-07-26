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

// InitMyWallet implements domain.UserRepository.
func (ar *userRepository) InitMyWallet(c context.Context, data *domain.User) (*domain.Wallet, error) {
	collection := ar.database.Collection("wallet")
	wallet := &domain.Wallet{
		Amount:        0,
		NbrSurveys:    0,
		CCP:           "",
		PaymentMethod: "",
		UserID:        data.ID,
	}
	walletID, err1 := collection.InsertOne(c, wallet)
	if err1 != nil {
		log.Printf("Failed to init wallet: %v", err1)
		return nil, err1
	}
	log.Printf("Init wallet  with id %v", walletID)
	wallet.ID = walletID.(string)
	return wallet, nil
}

// UpdateMyWallet implements domain.UserRepository.
func (ar *userRepository) UpdateMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error) {
	panic("unimplemented")
}

// CheckMyWallet implements domain.UserRepository.
func (ar *userRepository) CheckMyWallet(c context.Context, user *domain.User) (*domain.Wallet, error) {
	panic("unimplemented")
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

func updateDoc(c context.Context, collection database.Collection, update primitive.M, filterUpdate primitive.D) (*domain.User, error) {
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
	fmt.Print("Document is updated successfuly")
	updatedUser, err := convertBsonToStruct[domain.User](updatedDocument)
	if err != nil {
		log.Printf("Failed to convert bson to struct: %v", err)
		return nil, err
	}
	return updatedUser, nil
}

// UpdateProfile implements domain.UserRepository.
func (ar *userRepository) UpdateProfile(c context.Context, data *domain.User) (*domain.User, error) {
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
			// "profilePicture": data.ProfilePicture,
		},
	}
	return updateDoc(c, collection, update, filterUpdate)
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

// RsetPassword implements domain.UserRepository.
func (ar *userRepository) RsetPassword(c context.Context, data *domain.RestPasswordModel) (*domain.User, error) {
	collection := ar.database.Collection("users")
	filterUpdate := bson.D{{Key: "email", Value: data.Email}}
	update := bson.M{
		"$set": bson.M{
			"password": data.NewPassword,
		},
	}
	return updateDoc(c, collection, update, filterUpdate)
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
func (ar *userRepository) Login(c context.Context, data *domain.LoginModel) (*domain.User, error) {
	collection := ar.database.Collection("users")
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
	User.Email = data.Email
	User.Username = resulat["username"].(string)
	User.FirstName = resulat["firstname"].(string)
	User.LastName = resulat["lastname"].(string)
	User.Phone = resulat["phone"].(string)
	User.Role = Role
	return User, nil
}
