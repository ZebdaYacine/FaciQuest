package util

func GenerateRole(role_id string) string {
	switch role_id {
	case "1":
		return "Admin"
	case "2":
		return "User"
	default:
		return "Guest"
	}
}
