package controller

import (
	"back-end/api/controller/model"
	"back-end/internal/domain"
	"back-end/internal/usecase"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

type DashBoardController struct {
	DashboardUsecase usecase.DashboardUsecase
}

// GetUsersRequest handles the user listing with filters
func (dc *DashBoardController) GetUsersRequest(c *gin.Context) {
	log.Println("__________________________RECEIVING GET USERS REQUEST__________________________")

	q := c.Request.URL.Query()

	var (
		limitPtr  *int
		offsetPtr *int
		isActive  *bool
		gender    *string
		minSurv   *int
		maxSurv   *int
		minPart   *int
		maxPart   *int
	)

	// limit
	if lv := q.Get("limit"); lv != "" {
		if v, err := strconv.Atoi(lv); err == nil {
			limitPtr = &v
		} else {
			c.JSON(http.StatusBadRequest, gin.H{"error": "invalid limit"})
			return
		}
	}

	// page -> offset = (page-1)*limit
	if pv := q.Get("page"); pv != "" {
		page, err := strconv.Atoi(pv)
		if err != nil || page <= 0 {
			c.JSON(http.StatusBadRequest, gin.H{"error": "invalid page"})
			return
		}
		l := 50
		if limitPtr != nil {
			l = *limitPtr
		}
		off := (page - 1) * l
		offsetPtr = &off
		if limitPtr == nil {
			limitPtr = &l
		}
	}

	// is_active
	if av := q.Get("is_active"); av != "" {
		if av == "true" || av == "false" {
			b := av == "true"
			isActive = &b
		} else {
			c.JSON(http.StatusBadRequest, gin.H{"error": "invalid is_active"})
			return
		}
	}

	// gender
	if gv := q.Get("gender"); gv != "" {
		gender = &gv
	}

	// min/max surveys
	if v := q.Get("min_surveys"); v != "" {
		if i, err := strconv.Atoi(v); err == nil {
			minSurv = &i
		} else {
			c.JSON(http.StatusBadRequest, gin.H{"error": "invalid min_surveys"})
			return
		}
	}
	if v := q.Get("max_surveys"); v != "" {
		if i, err := strconv.Atoi(v); err == nil {
			maxSurv = &i
		} else {
			c.JSON(http.StatusBadRequest, gin.H{"error": "invalid max_surveys"})
			return
		}
	}

	// min/max participations
	if v := q.Get("min_participations"); v != "" {
		if i, err := strconv.Atoi(v); err == nil {
			minPart = &i
		} else {
			c.JSON(http.StatusBadRequest, gin.H{"error": "invalid min_participations"})
			return
		}
	}
	if v := q.Get("max_participations"); v != "" {
		if i, err := strconv.Atoi(v); err == nil {
			maxPart = &i
		} else {
			c.JSON(http.StatusBadRequest, gin.H{"error": "invalid max_participations"})
			return
		}
	}

	filter := &domain.UserFilter{
		IsActive:          isActive,
		Gender:            gender,
		Limit:             limitPtr,
		Offset:            offsetPtr,
		MinSurveys:        minSurv,
		MaxSurveys:        maxSurv,
		MinParticipations: minPart,
		MaxParticipations: maxPart,
	}

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

// GetAllPaymentsRequest handles the payment listing request
func (dc *DashBoardController) GetAllPaymentsRequest(c *gin.Context) {
	log.Println("__________________________RECEIVING GET ALL PAYMENTS REQUEST__________________________")

	// Pagination params
	q := c.Request.URL.Query()
	limit := 50
	offset := 0
	if lv := q.Get("limit"); lv != "" {
		if v, err := strconv.Atoi(lv); err == nil && v > 0 {
			limit = v
		} else {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid limit"})
			return
		}
	}
	if pv := q.Get("page"); pv != "" {
		if v, err := strconv.Atoi(pv); err == nil && v > 0 {
			offset = (v - 1) * limit
		} else {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid page"})
			return
		}
	}
	status := q.Get("status")

	result := dc.DashboardUsecase.GetAllPayments(c)
	if result.Err != nil {
		log.Printf("Error getting all payments: %v", result.Err)
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "Failed to retrieve payments"})
		return
	}

	payments := result.Data
	// Filter by status if provided
	if status != "" {
		filtered := make([]domain.PaymentWithUserInfo, 0, len(payments))
		for _, p := range payments {
			if p.Status == status {
				filtered = append(filtered, p)
			}
		}
		payments = filtered
	}

	total := len(payments)
	if offset > total {
		payments = []domain.PaymentWithUserInfo{}
	} else {
		end := offset + limit
		if end > total {
			end = total
		}
		payments = payments[offset:end]
	}

	c.JSON(http.StatusOK, model.SuccessResponse{Message: "Payments retrieved successfully", Data: payments})
}

// GetUserByIDRequest handles fetching a single user with stats by ID
func (dc *DashBoardController) GetUserByIDRequest(c *gin.Context) {
	userID := c.Param("userId")
	if userID == "" {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "userId is required"})
		return
	}

	result := dc.DashboardUsecase.GetUserByID(c, userID)
	if result.Err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: result.Err.Error()})
		return
	}

	c.JSON(http.StatusOK, model.SuccessResponse{Message: "User retrieved successfully", Data: result.Data})
}

// GetAnalyticsRequest handles analytics query over a period and date range
func (dc *DashBoardController) GetAnalyticsRequest(c *gin.Context) {
	period := c.Query("period")
	startStr := c.Query("start_date")
	endStr := c.Query("end_date")

	var startAt, endAt *time.Time
	if startStr != "" {
		t, err := time.Parse(time.RFC3339, startStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid start_date"})
			return
		}
		startAt = &t
	}
	if endStr != "" {
		t, err := time.Parse(time.RFC3339, endStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: "invalid end_date"})
			return
		}
		endAt = &t
	}

	res := dc.DashboardUsecase.GetAnalytics(c, usecase.AnalyticsParams{Period: period, StartAt: startAt, EndAt: endAt})
	if res.Err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{Message: res.Err.Error()})
		return
	}
	c.JSON(http.StatusOK, model.SuccessResponse{Message: "Analytics retrieved successfully", Data: res.Data})
}
