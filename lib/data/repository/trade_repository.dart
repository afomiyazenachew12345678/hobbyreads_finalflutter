import 'package:hobby_reads_flutter/data/api/api_service.dart';
import 'package:hobby_reads_flutter/data/model/trade_request_model.dart';

class TradeRepository {
  final ApiService _apiService;

  TradeRepository(this._apiService);

  // Get pending trade requests (both incoming and outgoing)
  Future<List<TradeRequestModel>> getPendingTradeRequests() async {
    try {
      final response = await _apiService.get('/trades/pending');
      
      // Backend returns array directly
      final List<dynamic> tradesData = response is List ? response : response['data'] ?? [];
      
      return tradesData
          .map((trade) => TradeRequestModel.fromBackendJson(trade as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleTradeError(e);
    }
  }

  // Get accepted trade requests
  Future<List<TradeRequestModel>> getAcceptedTradeRequests() async {
    try {
      final response = await _apiService.get('/trades/accepted');
      
      final List<dynamic> tradesData = response is List ? response : response['data'] ?? [];
      
      return tradesData
          .map((trade) => TradeRequestModel.fromBackendJson(trade as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleTradeError(e);
    }
  }

  // Create a new trade request
  Future<TradeRequestModel> createTradeRequest({
    required String bookId,
    String? message,
  }) async {
    try {
      final response = await _apiService.post('/trades', body: {
        'bookId': bookId,
        if (message != null) 'message': message,
      });
      
      return TradeRequestModel.fromBackendJson(_extractData(response));
    } catch (e) {
      throw _handleTradeError(e);
    }
  }

  // Update trade request status (accept, reject, cancel)
  Future<TradeRequestModel> updateTradeRequestStatus({
    required String tradeId,
    required String status,
  }) async {
    try {
      final response = await _apiService.put('/trades/$tradeId', body: {
        'status': status,
      });
      
      return TradeRequestModel.fromBackendJson(_extractData(response));
    } catch (e) {
      throw _handleTradeError(e);
    }
  }

  // Accept a trade request
  Future<TradeRequestModel> acceptTradeRequest(String tradeId) {
    return updateTradeRequestStatus(tradeId: tradeId, status: 'accepted');
  }

  // Reject a trade request
  Future<TradeRequestModel> rejectTradeRequest(String tradeId) {
    return updateTradeRequestStatus(tradeId: tradeId, status: 'rejected');
  }

  // Cancel a trade request
  Future<TradeRequestModel> cancelTradeRequest(String tradeId) {
    return updateTradeRequestStatus(tradeId: tradeId, status: 'cancelled');
  }

  // Helper method to extract data from response
  Map<String, dynamic> _extractData(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response['data'] ?? response;
    }
    return response as Map<String, dynamic>;
  }

  // Handle trade-specific errors
  String _handleTradeError(dynamic error) {
    if (error is Map<String, dynamic>) {
      // Handle API error response - prefer specific backend messages
      if (error.containsKey('message')) {
        return error['message'] as String;
      }
      if (error.containsKey('error')) {
        return error['error'] as String;
      }
    }

    final errorMessage = error.toString();
    
    // Extract specific error messages from ApiException format
    final apiExceptionMatch = RegExp(r'\[(\d+)\] (.+)').firstMatch(errorMessage);
    if (apiExceptionMatch != null) {
      final statusCode = int.parse(apiExceptionMatch.group(1)!);
      final message = apiExceptionMatch.group(2)!;
      
      // Return the specific backend message for 400 errors (like "This book is not available for trade!")
      if (statusCode == 400 && message.isNotEmpty) {
        return message;
      }
      
      // Handle other specific status codes
      switch (statusCode) {
        case 404:
          return message.isNotEmpty ? message : 'Trade request not found';
        case 403:
          return message.isNotEmpty ? message : 'You are not authorized to perform this action';
        case 500:
          return message.isNotEmpty ? message : 'Server error occurred';
        default:
          return message.isNotEmpty ? message : 'An error occurred while processing the trade request';
      }
    }
    
    // Handle network errors
    if (errorMessage.contains('network') || errorMessage.contains('connection')) {
      return 'Network error. Please check your connection and try again.';
    }

    // Fallback for any other errors
    return 'An error occurred while processing the trade request';
  }
} 