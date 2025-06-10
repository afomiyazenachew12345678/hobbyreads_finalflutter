import 'package:hobby_reads_flutter/data/api/api_service.dart';
import 'package:hobby_reads_flutter/data/model/auth_model.dart';
import 'package:hobby_reads_flutter/data/model/connection_model.dart';


class ConnectionRepository {
  final ApiService _apiService;

  ConnectionRepository(this._apiService);

  // Connection Requests
  Future<List<ConnectionModel>> getPendingRequests({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get(
        '/connections/requests/pending?${Uri(queryParameters: queryParams).query}',
      );

      return (response['data'] as List)
          .map((request) => ConnectionModel.fromJson(request))
          .toList();
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<ConnectionModel> sendConnectionRequest(String userId) async {
    try {
      final response = await _apiService.post(
        '/connections/requests',
        body: {'userId': userId},
      );
      return ConnectionModel.fromJson(response['data']);
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<ConnectionModel> respondToRequest({
    required String requestId,
    required bool accept,
    String? message,
  }) async {
    try {
      final response = await _apiService.patch(
        '/connections/requests/$requestId',
        body: {
          'status': accept ? 'accepted' : 'rejected',
          if (message != null) 'message': message,
        },
      );
      return ConnectionModel.fromJson(response['data']);
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<void> cancelRequest(String requestId) async {
    try {
      await _apiService.delete('/connections/requests/$requestId');
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  // Connection Management
  Future<List<ConnectionModel>> getConnections({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null) 'search': search,
      };

      final response = await _apiService.get(
        '/connections?${Uri(queryParameters: queryParams).query}',
      );

      return (response['data'] as List)
          .map((connection) => ConnectionModel.fromJson(connection))
          .toList();
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<ConnectionModel> getConnection(String userId) async {
    try {
      final response = await _apiService.get('/connections/$userId');
      return ConnectionModel.fromJson(response['data']);
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<void> removeConnection(String userId) async {
    try {
      await _apiService.delete('/connections/$userId');
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<void> blockUser(String userId) async {
    try {
      await _apiService.post(
        '/connections/block',
        body: {'userId': userId},
      );
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      await _apiService.delete('/connections/block/$userId');
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  // Connection Status
  Future<String> getConnectionStatus(String userId) async {
    try {
      final response = await _apiService.get('/connections/status/$userId');
      return response['data']['status'];
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<bool> isConnected(String userId) async {
    try {
      final response = await _apiService.get('/connections/check/$userId');
      return response['data']['isConnected'];
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<bool> isBlocked(String userId) async {
    try {
      final response = await _apiService.get('/connections/blocked/$userId');
      return response['data']['isBlocked'];
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  // Connection Suggestions
  Future<List<ConnectionModel>> getConnectionSuggestions({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get(
        '/connections/suggestions?${Uri(queryParameters: queryParams).query}',
      );

      return (response['data'] as List)
          .map((suggestion) => ConnectionModel.fromJson(suggestion))
          .toList();
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  // Connection Activity
  Future<List<Map<String, dynamic>>> getConnectionActivity({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get(
        '/connections/$userId/activity?${Uri(queryParameters: queryParams).query}',
      );

      return (response['data'] as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  // Connection Settings
  Future<Map<String, dynamic>> getConnectionSettings() async {
    try {
      final response = await _apiService.get('/connections/settings');
      return response['data'];
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  Future<void> updateConnectionSettings({
    bool? allowFriendRequests,
    bool? showOnlineStatus,
    bool? showReadingActivity,
    List<String>? privacyLevels,
  }) async {
    try {
      await _apiService.patch(
        '/connections/settings',
        body: {
          if (allowFriendRequests != null)
            'allowFriendRequests': allowFriendRequests,
          if (showOnlineStatus != null) 'showOnlineStatus': showOnlineStatus,
          if (showReadingActivity != null)
            'showReadingActivity': showReadingActivity,
          if (privacyLevels != null) 'privacyLevels': privacyLevels,
        },
      );
    } catch (e) {
      throw _handleConnectionError(e);
    }
  }

  // Error Handling
  String _handleConnectionError(dynamic error) {
    if (error is ApiException) {
      switch (error.statusCode) {
        case 400:
          return 'Invalid connection request data.';
        case 401:
          return 'Authentication required.';
        case 403:
          return 'You do not have permission to perform this action.';
        case 404:
          return 'User or connection not found.';
        case 409:
          return 'Connection request already exists.';
        case 422:
          return 'Invalid input data.';
        case 500:
          return 'Server error. Please try again later.';
        default:
          return error.message;
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
} 