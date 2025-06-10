import 'package:hobby_reads_flutter/data/api/api_service.dart';
import 'package:hobby_reads_flutter/data/model/auth_model.dart';
import 'package:hobby_reads_flutter/data/repository/token_manager_repository.dart';

class AuthRepository {
  final ApiService _apiService;
  final TokenManagerRepository _tokenManager;

  AuthRepository(this._apiService, this._tokenManager);

  // Authentication
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );
      
      await _tokenManager.saveTokens(
        accessToken: response['accessToken'],
        refreshToken: response['refreshToken'],
        expiryDate: DateTime.parse(response['expiresAt']),
      );
      
      return AuthModel.fromJson(response['user']);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<AuthModel> register({
    required String email,
    required String password,
    required String name,
    String? handle,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        body: {
          'email': email,
          'password': password,
          'name': name,
          if (handle != null) 'handle': handle,
        },
      );
      
      await _tokenManager.saveTokens(
        accessToken: response['accessToken'],
        refreshToken: response['refreshToken'],
        expiryDate: DateTime.parse(response['expiresAt']),
      );
      
      return AuthModel.fromJson(response['user']);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post(
        '/auth/logout',
        body: {},
      );
      await _tokenManager.clearTokens();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.post(
        '/auth/forgot-password',
        body: {'email': email},
      );
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _apiService.post(
        '/auth/reset-password',
        body: {
          'token': token,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _apiService.post(
        '/auth/change-password',
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // Profile Management
  Future<AuthModel> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me');
      return AuthModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<AuthModel> updateProfile({
    String? name,
    String? handle,
    String? bio,
    String? profilePicture,
  }) async {
    try {
      final response = await _apiService.put(
        '/auth/profile',
        body: {
          if (name != null) 'name': name,
          if (handle != null) 'handle': handle,
          if (bio != null) 'bio': bio,
          if (profilePicture != null) 'profilePicture': profilePicture,
        },
      );
      return AuthModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _apiService.delete('/auth/account');
      await _tokenManager.clearTokens();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // Email Verification
  Future<void> sendVerificationEmail() async {
    try {
      await _apiService.post(
        '/auth/send-verification',
        body: {},
      );
    } catch (e) {
      throw Exception('Failed to send verification email: $e');
    }
  }

  Future<void> verifyEmail(String token) async {
    try {
      await _apiService.post(
        '/auth/verify-email',
        body: {'token': token},
      );
    } catch (e) {
      throw Exception('Failed to verify email: $e');
    }
  }

  // Session Management
  Future<void> refreshToken() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _apiService.post(
        '/auth/refresh',
        body: {'refreshToken': refreshToken},
      );

      await _tokenManager.saveTokens(
        accessToken: response['accessToken'],
        refreshToken: response['refreshToken'],
        expiryDate: DateTime.parse(response['expiresAt']),
      );
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    return _tokenManager.hasValidTokens();
  }

  // Social Authentication
  Future<AuthModel> loginWithGoogle(String idToken) async {
    try {
      final response = await _apiService.post(
        '/auth/google',
        body: {'idToken': idToken},
      );
      
      await _tokenManager.saveTokens(
        accessToken: response['accessToken'],
        refreshToken: response['refreshToken'],
        expiryDate: DateTime.parse(response['expiresAt']),
      );
      
      return AuthModel.fromJson(response['user']);
    } catch (e) {
      throw Exception('Failed to login with Google: $e');
    }
  }

  Future<AuthModel> loginWithApple(String identityToken) async {
    try {
      final response = await _apiService.post(
        '/auth/apple',
        body: {'identityToken': identityToken},
      );
      
      await _tokenManager.saveTokens(
        accessToken: response['accessToken'],
        refreshToken: response['refreshToken'],
        expiryDate: DateTime.parse(response['expiresAt']),
      );
      
      return AuthModel.fromJson(response['user']);
    } catch (e) {
      throw Exception('Failed to login with Apple: $e');
    }
  }
} 