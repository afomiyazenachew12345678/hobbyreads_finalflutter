import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_reads_flutter/data/model/trade_request_model.dart';
import 'package:hobby_reads_flutter/data/repository/trade_repository.dart';
import 'package:hobby_reads_flutter/providers/api_providers.dart';
import 'package:hobby_reads_flutter/providers/auth_providers.dart';
import 'package:hobby_reads_flutter/providers/book_providers.dart';

// Trade Requests State
class TradeRequestsState {
  final List<TradeRequestModel> requests;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const TradeRequestsState({
    this.requests = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  TradeRequestsState copyWith({
    List<TradeRequestModel>? requests,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return TradeRequestsState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

// Pending Trade Requests Notifier
class PendingTradeRequestsNotifier extends StateNotifier<TradeRequestsState> {
  final TradeRepository _tradeRepository;
  final Ref _ref;

  PendingTradeRequestsNotifier(this._tradeRepository, this._ref) : super(const TradeRequestsState()) {
    // Listen to auth state changes and reload data when user changes
    _ref.listen(authProvider, (previous, next) {
      if (previous?.user?.id != next.user?.id) {
        if (next.isAuthenticated) {
          loadPendingRequests();
        } else {
          state = const TradeRequestsState();
        }
      }
    });
  }

  Future<void> loadPendingRequests() async {
    // Only load if user is authenticated
    if (!_ref.read(isAuthenticatedProvider)) {
      state = const TradeRequestsState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      final requests = await _tradeRepository.getPendingTradeRequests();
      state = TradeRequestsState(
        requests: requests,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> acceptTradeRequest(String tradeId) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      final updatedRequest = await _tradeRepository.acceptTradeRequest(tradeId);
      
      // Remove from pending list and add success message
      final updatedRequests = state.requests
          .where((req) => req.id != tradeId)
          .toList();
      
      state = state.copyWith(
        requests: updatedRequests,
        isLoading: false,
        successMessage: 'Trade request accepted successfully',
      );

      // Refresh accepted requests
      _ref.read(acceptedTradeRequestsProvider.notifier).loadAcceptedRequests();
      
      // Invalidate books provider to refresh book statuses
      _ref.invalidate(booksProvider);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> rejectTradeRequest(String tradeId) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      await _tradeRepository.rejectTradeRequest(tradeId);
      
      // Remove from pending list
      final updatedRequests = state.requests
          .where((req) => req.id != tradeId)
          .toList();
      
      state = state.copyWith(
        requests: updatedRequests,
        isLoading: false,
        successMessage: 'Trade request rejected',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> cancelTradeRequest(String tradeId) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      await _tradeRepository.cancelTradeRequest(tradeId);
      
      // Remove from pending list
      final updatedRequests = state.requests
          .where((req) => req.id != tradeId)
          .toList();
      
      state = state.copyWith(
        requests: updatedRequests,
        isLoading: false,
        successMessage: 'Trade request cancelled',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createTradeRequest({
    required String bookId,
    String? message,
  }) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      final newRequest = await _tradeRepository.createTradeRequest(
        bookId: bookId,
        message: message,
      );
      
      // Only add to pending list and show success after backend confirms
      final updatedRequests = [...state.requests, newRequest];
      
      state = state.copyWith(
        requests: updatedRequests,
        isLoading: false,
        successMessage: 'Trade request sent successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

// Accepted Trade Requests Notifier
class AcceptedTradeRequestsNotifier extends StateNotifier<TradeRequestsState> {
  final TradeRepository _tradeRepository;
  final Ref _ref;

  AcceptedTradeRequestsNotifier(this._tradeRepository, this._ref) : super(const TradeRequestsState()) {
    // Listen to auth state changes and reload data when user changes
    _ref.listen(authProvider, (previous, next) {
      if (previous?.user?.id != next.user?.id) {
        if (next.isAuthenticated) {
          loadAcceptedRequests();
        } else {
          state = const TradeRequestsState();
        }
      }
    });
  }

  Future<void> loadAcceptedRequests() async {
    // Only load if user is authenticated
    if (!_ref.read(isAuthenticatedProvider)) {
      state = const TradeRequestsState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      final requests = await _tradeRepository.getAcceptedTradeRequests();
      state = TradeRequestsState(
        requests: requests,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

// Pending Trade Requests Provider
final pendingTradeRequestsProvider = StateNotifierProvider<PendingTradeRequestsNotifier, TradeRequestsState>((ref) {
  final tradeRepository = ref.watch(tradeRepositoryProvider);
  final notifier = PendingTradeRequestsNotifier(tradeRepository, ref);
  
  // Auto-load when provider is first created and user is authenticated
  if (ref.read(isAuthenticatedProvider)) {
    notifier.loadPendingRequests();
  }
  
  return notifier;
});

// Accepted Trade Requests Provider
final acceptedTradeRequestsProvider = StateNotifierProvider<AcceptedTradeRequestsNotifier, TradeRequestsState>((ref) {
  final tradeRepository = ref.watch(tradeRepositoryProvider);
  final notifier = AcceptedTradeRequestsNotifier(tradeRepository, ref);
  
  // Auto-load when provider is first created and user is authenticated
  if (ref.read(isAuthenticatedProvider)) {
    notifier.loadAcceptedRequests();
  }
  
  return notifier;
});

// Simple providers for quick access
final pendingTradeRequestsCountProvider = Provider<int>((ref) {
  final pendingState = ref.watch(pendingTradeRequestsProvider);
  return pendingState.requests.length;
});

final acceptedTradeRequestsCountProvider = Provider<int>((ref) {
  final acceptedState = ref.watch(acceptedTradeRequestsProvider);
  return acceptedState.requests.length;
});

// Incoming and Outgoing Trade Requests Providers
final incomingTradeRequestsProvider = Provider<List<TradeRequestModel>>((ref) {
  final pendingState = ref.watch(pendingTradeRequestsProvider);
  final currentUserId = ref.watch(userProvider)?.id;
  
  if (currentUserId == null) return [];
  
  return pendingState.requests
      .where((request) => request.receiverId == currentUserId)
      .toList();
});

final outgoingTradeRequestsProvider = Provider<List<TradeRequestModel>>((ref) {
  final pendingState = ref.watch(pendingTradeRequestsProvider);
  final currentUserId = ref.watch(userProvider)?.id;
  
  if (currentUserId == null) return [];
  
  return pendingState.requests
      .where((request) => request.senderId == currentUserId)
      .toList();
});

final incomingTradeRequestsCountProvider = Provider<int>((ref) {
  final incomingRequests = ref.watch(incomingTradeRequestsProvider);
  return incomingRequests.length;
});

final outgoingTradeRequestsCountProvider = Provider<int>((ref) {
  final outgoingRequests = ref.watch(outgoingTradeRequestsProvider);
  return outgoingRequests.length;
});

// Global refresh function provider
final tradeRefreshProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(pendingTradeRequestsProvider);
    ref.invalidate(acceptedTradeRequestsProvider);
  };
}); 