package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"fmt"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type DashBoardRepository interface {
	GetUserList(c context.Context, filter *domain.UserFilter) (*domain.UserListResponse, error)
	GetDashboardStats(c context.Context) (*domain.DashboardStats, error)
	GetAllPayments(c context.Context) ([]domain.PaymentWithUserInfo, error)
}

type dashboardRepository struct {
	database database.Database
}

func NewDashboardRepository(db database.Database) DashBoardRepository {
	return &dashboardRepository{
		database: db,
	}
}

// GetUserList implements DashBoardRepository.
func (d *dashboardRepository) GetUserList(c context.Context, filter *domain.UserFilter) (*domain.UserListResponse, error) {
	usersCollection := d.database.Collection("users")
	surveysCollection := d.database.Collection("survey")
	submissionsCollection := d.database.Collection("submission")

	// Build filter for users
	userFilter := bson.M{}

	if filter.IsActive != nil {
		userFilter["isActive"] = *filter.IsActive
	}
	if filter.Gender != nil && *filter.Gender != "" {
		userFilter["gender"] = *filter.Gender
	}
	if filter.Country != nil && *filter.Country != "" {
		userFilter["country"] = *filter.Country
	}
	if filter.Education != nil && *filter.Education != "" {
		userFilter["education"] = *filter.Education
	}

	// Get users with basic info
	cursor, err := usersCollection.Find(c, userFilter)
	if err != nil {
		log.Printf("Failed to find users: %v", err)
		return nil, err
	}
	defer cursor.Close(c)

	var users []domain.UserStats
	for cursor.Next(c) {
		var user bson.M
		if err := cursor.Decode(&user); err != nil {
			log.Printf("Failed to decode user: %v", err)
			continue
		}

		userID := user["_id"]

		// Get survey count for this user
		surveyFilter := bson.M{"surveybadge.userId": userID.(primitive.ObjectID).Hex()}
		surveyCount, err := surveysCollection.CountDocuments(c, surveyFilter)
		if err != nil {
			log.Printf("Failed to count surveys for user %s: %v", userID, err)
			surveyCount = 0
		}

		// Get participation count for this user
		participationFilter := bson.M{"userId": userID.(primitive.ObjectID).Hex()}
		participationCount, err := submissionsCollection.CountDocuments(c, participationFilter)
		if err != nil {
			log.Printf("Failed to count participations for user %s: %v", userID, err)
			participationCount = 0
		}

		userStats := domain.UserStats{
			ID:                 userID.(primitive.ObjectID).Hex(),
			Username:           getStringValue(user, "username"),
			FirstName:          getStringValue(user, "firstname"),
			LastName:           getStringValue(user, "lastname"),
			Email:              getStringValue(user, "email"),
			Phone:              getStringValue(user, "phone"),
			Age:                getInt64Value(user, "age"),
			Country:            getStringValue(user, "country"),
			Education:          getStringValue(user, "education"),
			Gender:             getStringValue(user, "gender"),
			SurveyCount:        int(surveyCount),
			ParticipationCount: int(participationCount),
			LastActivity:       getInt64Value(user, "lastActivity"), // Check if last activity was within the last 30 days
		}

		users = append(users, userStats)
	}

	// Apply pagination
	limit := 50 // default limit
	offset := 0 // default offset

	if filter.Limit != nil && *filter.Limit > 0 {
		limit = *filter.Limit
	}
	if filter.Offset != nil && *filter.Offset >= 0 {
		offset = *filter.Offset
	}

	total := len(users)

	// Apply pagination
	if offset >= total {
		users = []domain.UserStats{}
	} else {
		end := offset + limit
		if end > total {
			end = total
		}
		users = users[offset:end]
	}

	// Get dashboard stats
	stats, err := d.GetDashboardStats(c)
	if err != nil {
		log.Printf("Failed to get dashboard stats: %v", err)
		stats = &domain.DashboardStats{}
	}

	return &domain.UserListResponse{
		Users:  users,
		Stats:  *stats,
		Total:  total,
		Limit:  limit,
		Offset: offset,
	}, nil
}

// GetDashboardStats implements DashBoardRepository.
func (d *dashboardRepository) GetDashboardStats(c context.Context) (*domain.DashboardStats, error) {
	usersCollection := d.database.Collection("users")
	surveysCollection := d.database.Collection("survey")
	submissionsCollection := d.database.Collection("submission")

	// Get total users
	totalUsers, err := usersCollection.CountDocuments(c, bson.M{})
	if err != nil {
		log.Printf("Failed to count total users: %v", err)
		return nil, err
	}

	// Get active users (users with activity in last 30 days)
	// thirtyDaysAgo := time.Now().Unix() - 30*24*60*60
	// activeUsersFilter := bson.M{"lastActivity": bson.M{"$gte": thirtyDaysAgo}}
	// activeUsers, err := usersCollection.CountDocuments(c, activeUsersFilter)
	// if err != nil {
	// 	log.Printf("Failed to count active users: %v", err)
	// 	activeUsers = 0
	// }

	// Get total surveys
	totalSurveys, err := surveysCollection.CountDocuments(c, bson.M{})
	if err != nil {
		log.Printf("Failed to count total surveys: %v", err)
		totalSurveys = 0
	}

	// Get total participations
	totalParticipations, err := submissionsCollection.CountDocuments(c, bson.M{})
	if err != nil {
		log.Printf("Failed to count total participations: %v", err)
		totalParticipations = 0
	}

	return &domain.DashboardStats{
		TotalUsers: int(totalUsers),
		// ActiveUsers:         int(activeUsers),
		TotalSurveys:        int(totalSurveys),
		TotalParticipations: int(totalParticipations),
	}, nil
}

// Helper functions to safely extract values from bson.M
func getStringValue(data bson.M, key string) string {
	if value, ok := data[key].(string); ok {
		return value
	}
	return ""
}

func getInt64Value(data bson.M, key string) int64 {
	if value, ok := data[key].(int64); ok {
		return value
	}
	return 0
}

// GetAllPayments implements DashBoardRepository.
func (d *dashboardRepository) GetAllPayments(c context.Context) ([]domain.PaymentWithUserInfo, error) {
	collection := d.database.Collection("payment")
	usersCollection := d.database.Collection("users")

	cursor, err := collection.Find(c, bson.M{})
	if err != nil {
		log.Printf("Failed to find payments: %v", err)
		return nil, fmt.Errorf("failed to retrieve payments: %v", err)
	}
	defer cursor.Close(c)

	var payments []domain.PaymentWithUserInfo
	for cursor.Next(c) {
		var payment bson.M
		if err := cursor.Decode(&payment); err != nil {
			log.Printf("Failed to decode payment: %v", err)
			continue
		}

		// Get user information
		var userFirstName, userLastName, userPhone, userEmail string
		if walletData, exists := payment["wallet"]; exists {
			if walletMap, ok := walletData.(bson.M); ok {
				if userID, exists := walletMap["userid"]; exists {
					// Fetch user data
					userObjectID, err := primitive.ObjectIDFromHex(userID.(string))
					if err == nil {
						var user bson.M
						userFilter := bson.D{{Key: "_id", Value: userObjectID}}
						err := usersCollection.FindOne(c, userFilter).Decode(&user)
						if err == nil {
							userFirstName = getStringValue(user, "firstname")
							userLastName = getStringValue(user, "lastname")
							userPhone = getStringValue(user, "phone")
							userEmail = getStringValue(user, "email")
						}
					}
				}
			}
		}

		// Format dates
		requestDate := formatDate(payment["payment_request_date"].(int64))
		paymentDate := ""
		if paymentDateUnix, exists := payment["payment_date"]; exists && paymentDateUnix != nil {
			paymentDate = formatDate(paymentDateUnix.(int64))
		}

		// Convert bson.M to domain.PaymentWithUserInfo
		paymentDoc := domain.PaymentWithUserInfo{
			ID:                 payment["_id"].(primitive.ObjectID).Hex(),
			Amount:             payment["amount"].(float64),
			Status:             payment["status"].(string),
			PaymentRequestDate: requestDate,
			PaymentDate:        paymentDate,
			UserFirstName:      userFirstName,
			UserLastName:       userLastName,
			UserPhone:          userPhone,
			UserEmail:          userEmail,
		}
		// paymentDoc.Wallet = domain.Wallet{}

		// Handle wallet data
		if walletData, exists := payment["wallet"]; exists {
			if walletMap, ok := walletData.(bson.M); ok {
				paymentDoc.Wallet = domain.Wallet{
					UserID:        walletMap["userid"].(string),
					Amount:        walletMap["amount"].(float64),
					TempAmount:    walletMap["temp_amount"].(float64),
					CCP:           walletMap["ccp"].(string),
					RIP:           walletMap["rip"].(string),
					PaymentMethod: walletMap["payment_method"].(string),
				}
			}
		}

		payments = append(payments, paymentDoc)
	}

	if err := cursor.Err(); err != nil {
		log.Printf("Cursor error: %v", err)
		return nil, fmt.Errorf("cursor error: %v", err)
	}

	return payments, nil
}

// formatDate converts Unix timestamp to "1-1-2025" format
func formatDate(unixTimestamp int64) string {
	if unixTimestamp == 0 {
		return ""
	}
	t := time.Unix(unixTimestamp, 0)
	return fmt.Sprintf("%d-%d-%d", t.Day(), t.Month(), t.Year())
}
