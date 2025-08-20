package controller

import (
	"back-end/api/controller/model"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type DashBoardController struct {
	DashboardUsecase usecase.DashboardUsecase
}

// GetUsersRequest handles the user listing with filters
func (dc *DashBoardController) GetUsersRequest(c *gin.Context) {
	log.Println("__________________________RECEIVING GET USERS REQUEST__________________________")
	filter := &domain.UserFilter{}
	if err := c.ShouldBindJSON(filter); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	log.Println(*filter.Country)

	params := &usecase.DashboardParams{Data: filter}
	result := dc.DashboardUsecase.GetListOfUsers(c, params)

	if result.Err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to retrieve users",
		})
		return
	}

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "Users retrieved successfully",
		Data:    result.Data,
	})
}

// GetDashboardStatsRequest handles the dashboard statistics
func (dc *DashBoardController) GetDashboardStatsRequest(c *gin.Context) {
	log.Println("__________________________RECEIVING GET DASHBOARD STATS REQUEST__________________________")

	result := dc.DashboardUsecase.GetDashboardStats(c)

	if result.Err != nil {
		log.Printf("Error getting dashboard stats: %v", result.Err)
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to retrieve dashboard statistics",
		})
		return
	}

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "Dashboard statistics retrieved successfully",
		Data:    result.Data,
	})
}

// GetUserNumberRequest - simple endpoint for getting user count (keeping original functionality)
func (dc *DashBoardController) GetUserNumberRequest(c *gin.Context) {
	log.Println("__________________________RECEIVING GET USER NUMBER REQUEST__________________________")

	// Get dashboard stats to extract user count
	result := dc.DashboardUsecase.GetDashboardStats(c)

	if result.Err != nil {
		log.Printf("Error getting user number: %v", result.Err)
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to retrieve user count",
		})
		return
	}

	c.JSON(http.StatusOK, model.SuccessResponse{
		Message: "User count retrieved successfully",
		Data: map[string]interface{}{
			"totalUsers": result.Data.TotalUsers,
			// "activeUsers": result.Data.ActiveUsers,
		},
	})
}
