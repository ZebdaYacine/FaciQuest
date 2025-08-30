class AdminUser {
  final String id;
  final String username;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'admin',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      lastLoginAt: json['last_login_at'] != null ? DateTime.tryParse(json['last_login_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': username, 'password': password};
  }
}

class LoginResponse {
  final String token;
  final AdminUser user;
  final int expiresIn;

  LoginResponse({required this.token, required this.user, required this.expiresIn});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      user: AdminUser.fromJson(json['userdata']['Data'] ?? {}),
      expiresIn: json['expires_in'] ?? 3600,
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user.toJson(), 'expires_in': expiresIn};
  }
}

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }
