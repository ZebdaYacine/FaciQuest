package usecase

import (
	"back-end/internal/domain"
	"back-end/internal/repository"
	"context"
	"fmt"
	"log"
)

type DashboardParams struct {
	Data *domain.UserFilter
}

type DashboardResulat struct {
	Data *domain.UserListResponse
	Err  error
}

type DashboardStatsResulat struct {
	Data *domain.DashboardStats
	Err  error
}

var (
	dashBoardResulat      = &DashboardResulat{}
	dashboardStatsResulat = &DashboardStatsResulat{}
)

type DashboardUsecase interface {
	GetListOfUsers(c context.Context, data *DashboardParams) *DashboardResulat
	GetDashboardStats(c context.Context) *DashboardStatsResulat
	GetAllPayments(c context.Context) *PaymentListResulat
}

type dashboardUsecase struct {
	repo       repository.DashBoardRepository
	collection string
}

func NewDashBoardUsecase(repo repository.DashBoardRepository, collection string) DashboardUsecase {
	return &dashboardUsecase{
		repo:       repo,
		collection: collection,
	}
}

// GetListOfUsers implements DashboardUsecase.
func (d *dashboardUsecase) GetListOfUsers(c context.Context, params *DashboardParams) *DashboardResulat {
	log.Println("LAUNCHING GET LIST OF USERS USE CASE")

	if params == nil {
		dashBoardResulat.Err = fmt.Errorf("parameters are required")
		return dashBoardResulat
	}

	// Use default filter if none provided
	filter := params.Data
	if filter == nil {
		filter = &domain.UserFilter{}
	}

	// Validate filter parameters
	if err := validateUserFilter(filter); err != nil {
		dashBoardResulat.Err = err
		return dashBoardResulat
	}

	// Get users from repository
	users, err := d.repo.GetUserList(c, filter)
	if err != nil {
		log.Printf("Failed to get user list: %v", err)
		dashBoardResulat.Err = fmt.Errorf("failed to retrieve users: %v", err)
		return dashBoardResulat
	}

	dashBoardResulat.Data = users
	dashBoardResulat.Err = nil
	return dashBoardResulat
}

// GetDashboardStats implements DashboardUsecase.
func (d *dashboardUsecase) GetDashboardStats(c context.Context) *DashboardStatsResulat {
	log.Println("LAUNCHING GET DASHBOARD STATS USE CASE")

	stats, err := d.repo.GetDashboardStats(c)
	if err != nil {
		log.Printf("Failed to get dashboard stats: %v", err)
		dashboardStatsResulat.Err = fmt.Errorf("failed to retrieve dashboard stats: %v", err)
		return dashboardStatsResulat
	}

	dashboardStatsResulat.Data = stats
	dashboardStatsResulat.Err = nil
	return dashboardStatsResulat
}

// validateUserFilter validates the user filter parameters
func validateUserFilter(filter *domain.UserFilter) error {

	// Validate pagination parameters
	if filter.Limit != nil && *filter.Limit <= 0 {
		return fmt.Errorf("limit must be greater than 0")
	}
	if filter.Limit != nil && *filter.Limit > 1000 {
		return fmt.Errorf("limit cannot exceed 1000")
	}
	if filter.Offset != nil && *filter.Offset < 0 {
		return fmt.Errorf("offset cannot be negative")
	}

	// Validate gender if provided
	if filter.Gender != nil && *filter.Gender != "" {
		validGenders := []string{"male", "female", "other", "prefer_not_to_say"}
		isValid := false
		for _, valid := range validGenders {
			if *filter.Gender == valid {
				isValid = true
				break
			}
		}
		if !isValid {
			return fmt.Errorf("invalid gender value. Must be one of: %v", validGenders)
		}
	}

	return nil
}

// GetAllPayments implements DashboardUsecase.
func (d *dashboardUsecase) GetAllPayments(c context.Context) *PaymentListResulat {
	log.Println("LAUNCHING GET ALL PAYMENTS USE CASE")

	payments, err := d.repo.GetAllPayments(c)
	if err != nil {
		log.Printf("Failed to get all payments: %v", err)
		return &PaymentListResulat{
			Data: nil,
			Err:  fmt.Errorf("failed to retrieve payments: %v", err),
		}
	}

	return &PaymentListResulat{
		Data: payments,
		Err:  nil,
	}
}
