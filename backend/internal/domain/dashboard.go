package domain

import "time"

type UserFilter struct {
	IsActive          *bool   `json:"isActive,omitempty"`
	Gender            *string `json:"gender,omitempty"`
	Country           *string `json:"country,omitempty"`
	Education         *string `json:"education,omitempty"`
	Limit             *int    `json:"limit,omitempty"`
	Offset            *int    `json:"offset,omitempty"`
	MinSurveys        *int    `json:"minSurveys,omitempty"`
	MaxSurveys        *int    `json:"maxSurveys,omitempty"`
	MinParticipations *int    `json:"minParticipations,omitempty"`
	MaxParticipations *int    `json:"maxParticipations,omitempty"`
}

type UserStats struct {
	ID                 string `json:"_id"`
	Username           string `json:"username"`
	FirstName          string `json:"firstname"`
	LastName           string `json:"lastname"`
	Email              string `json:"email"`
	Phone              string `json:"phone"`
	Age                int64  `json:"age"`
	Country            string `json:"country"`
	Education          string `json:"education"`
	IsActive           bool   `json:"isActive"`
	Gender             string `json:"gender"`
	SurveyCount        int    `json:"surveyCount"`
	ParticipationCount int    `json:"participationCount"`
	LastActivity       int64  `json:"lastActivity"`
}

type DashboardStats struct {
	TotalUsers int `json:"totalUsers"`
	// ActiveUsers                  int     `json:"activeUsers"`
	TotalSurveys        int `json:"totalSurveys"`
	TotalParticipations int `json:"totalParticipations"`
	// AverageSurveysPerUser        float64 `json:"averageSurveysPerUser"`
	// AverageParticipationsPerUser float64 `json:"averageParticipationsPerUser"`
}

type UserListResponse struct {
	Users  []UserStats    `json:"users"`
	Stats  DashboardStats `json:"stats"`
	Total  int            `json:"total"`
	Limit  int            `json:"limit"`
	Offset int            `json:"offset"`
}

type AnalyticsModel struct {
	TotalUsers           int       `json:"total_users"`
	ActiveUsers          int       `json:"active_users"`
	ActiveUserPercentage float64   `json:"active_user_percentage"`
	TotalSurveys         int       `json:"total_surveys"`
	TotalCashoutRequests int       `json:"total_cashout_requests"`
	TotalCashoutAmount   float64   `json:"total_cashout_amount"`
	PeriodStart          time.Time `json:"period_start"`
	PeriodEnd            time.Time `json:"period_end"`
}
