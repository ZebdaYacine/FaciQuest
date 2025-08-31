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
	GetUserByID(c context.Context, userID string) (*domain.UserStats, error)
	GetAnalytics(c context.Context, period string, startAt *time.Time, endAt *time.Time) (*domain.AnalyticsModel, error)
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
			IsActive:           getBoolValue(user, "isActive"),
			SurveyCount:        int(surveyCount),
			ParticipationCount: int(participationCount),
			LastActivity:       getInt64Value(user, "lastActivity"), // Check if last activity was within the last 30 days
		}

		// Apply min/max filters in-memory
		if filter.MinSurveys != nil && int64(*filter.MinSurveys) > int64(userStats.SurveyCount) {
			continue
		}
		if filter.MaxSurveys != nil && int64(*filter.MaxSurveys) < int64(userStats.SurveyCount) {
			continue
		}
		if filter.MinParticipations != nil && int64(*filter.MinParticipations) > int64(userStats.ParticipationCount) {
			continue
		}
		if filter.MaxParticipations != nil && int64(*filter.MaxParticipations) < int64(userStats.ParticipationCount) {
			continue
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
	// stats, err := d.GetDashboardStats(c)
	// if err != nil {
	// 	log.Printf("Failed to get dashboard stats: %v", err)
	// 	stats = &domain.DashboardStats{}
	// }

	return &domain.UserListResponse{
		Users: users,
		// Stats:  *stats,
		// Total:  total,
		// Limit:  limit,
		// Offset: offset,
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

func getBoolValue(data bson.M, key string) bool {
	if value, ok := data[key].(bool); ok {
		return value
	}
	return false
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

// GetUserByID fetches a single user and computes stats
func (d *dashboardRepository) GetUserByID(c context.Context, userID string) (*domain.UserStats, error) {
	usersCollection := d.database.Collection("users")
	surveysCollection := d.database.Collection("survey")
	submissionsCollection := d.database.Collection("submission")

	objID, err := primitive.ObjectIDFromHex(userID)
	if err != nil {
		return nil, fmt.Errorf("invalid userId")
	}

	var user bson.M
	if err := usersCollection.FindOne(c, bson.M{"_id": objID}).Decode(&user); err != nil {
		return nil, err
	}

	// Compute counts
	surveyCount, err := surveysCollection.CountDocuments(c, bson.M{"surveybadge.userId": userID})
	if err != nil {
		surveyCount = 0
	}
	participationCount, err := submissionsCollection.CountDocuments(c, bson.M{"userId": userID})
	if err != nil {
		participationCount = 0
	}

	stats := &domain.UserStats{
		ID:                 userID,
		Username:           getStringValue(user, "username"),
		FirstName:          getStringValue(user, "firstname"),
		LastName:           getStringValue(user, "lastname"),
		Email:              getStringValue(user, "email"),
		Phone:              getStringValue(user, "phone"),
		Age:                getInt64Value(user, "age"),
		Country:            getStringValue(user, "country"),
		Education:          getStringValue(user, "education"),
		IsActive:           getBoolValue(user, "isActive"),
		Gender:             getStringValue(user, "gender"),
		SurveyCount:        int(surveyCount),
		ParticipationCount: int(participationCount),
		LastActivity:       getInt64Value(user, "lastActivity"),
	}

	return stats, nil
}

// formatDate converts Unix timestamp to "1-1-2025" format
func formatDate(unixTimestamp int64) string {
	if unixTimestamp == 0 {
		return ""
	}
	t := time.Unix(unixTimestamp, 0)
	return fmt.Sprintf("%d-%d-%d", t.Day(), t.Month(), t.Year())
}

func (d *dashboardRepository) GetAnalytics(c context.Context, period string, startAt *time.Time, endAt *time.Time) (*domain.AnalyticsModel, error) {

	usersCollection := d.database.Collection("users")
	surveysCollection := d.database.Collection("survey")
	paymentsCollection := d.database.Collection("payment")

	// Base date filter for createdAt fields if present
	dateFilter := func(field string) bson.M {
		and := []bson.M{}
		if startAt != nil {
			and = append(and, bson.M{field: bson.M{"$gte": *startAt}})
		}
		if endAt != nil {
			and = append(and, bson.M{field: bson.M{"$lte": *endAt}})
		}
		if len(and) == 0 {
			return bson.M{}
		}

		return bson.M{"$and": and}
	}

	log.Println(" >>>>>>>>>>>>>> dateFilter", dateFilter("createdAt"))

	// Totals
	totalUsers, _ := usersCollection.CountDocuments(c, bson.M{})
	totalSurveys, _ := surveysCollection.CountDocuments(c, dateFilter("surveybadge.createdAt"))

	// Active users heuristic: lastActivity within 30 days
	thirtyDaysAgo := time.Now().AddDate(0, 0, -30).Unix()
	activeUsers, _ := usersCollection.CountDocuments(c, bson.M{"lastActivity": bson.M{"$gte": thirtyDaysAgo}})
	activePct := 0.0
	if totalUsers > 0 {
		activePct = float64(activeUsers) / float64(totalUsers) * 100.0
	}

	// Cashout requests/amount: payments

	cashoutCount, _ := paymentsCollection.CountDocuments(c, bson.M{})
	var totalAmount float64
	cur, err := paymentsCollection.Find(c, bson.M{})
	if err == nil {
		for cur.Next(c) {
			var p bson.M
			_ = cur.Decode(&p)
			if amt, ok := p["amount"].(float64); ok {
				totalAmount += amt
			}
		}
		_ = cur.Close(c)
	}

	result := &domain.AnalyticsModel{
		TotalUsers:           int(totalUsers),
		ActiveUsers:          int(activeUsers),
		ActiveUserPercentage: activePct,
		TotalSurveys:         int(totalSurveys),
		TotalCashoutRequests: int(cashoutCount),
		TotalCashoutAmount:   totalAmount,
	}

	if startAt != nil {
		result.PeriodStart = *startAt
	}
	if endAt != nil {
		result.PeriodEnd = *endAt
	}
	return result, nil
}
