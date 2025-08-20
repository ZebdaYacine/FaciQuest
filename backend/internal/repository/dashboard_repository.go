package repository

import (
	"back-end/internal/domain"
	"back-end/pkg/database"
	"context"
	"log"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type DashBoardRepository interface {
	GetUserList(c context.Context, filter *domain.UserFilter) (*domain.UserListResponse, error)
	GetDashboardStats(c context.Context) (*domain.DashboardStats, error)
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
