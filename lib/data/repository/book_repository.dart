import 'package:hobby_reads_flutter/data/api/api_service.dart';
import 'package:hobby_reads_flutter/data/model/book_model.dart';
import 'package:hobby_reads_flutter/data/model/review_model.dart';
import 'package:hobby_reads_flutter/data/model/trade_request_model.dart';

class BookRepository {
  final ApiService _apiService;

  BookRepository(this._apiService);

  // Book Management
  Future<List<BookModel>> getBooks({
    int page = 1,
    int limit = 10,
    String? search,
    String? genre,
    String? author,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null) 'search': search,
        if (genre != null) 'genre': genre,
        if (author != null) 'author': author,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      };

      final response = await _apiService.get(
        '/books?${Uri(queryParameters: queryParams).query}',
      );

      return (response['data'] as List)
          .map((book) => BookModel.fromJson(book))
          .toList();
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<BookModel> getBookById(String bookId) async {
    try {
      final response = await _apiService.get('/books/$bookId');
      return BookModel.fromJson(response['data']);
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<BookModel> addBook({
    required String title,
    required String author,
    required String isbn,
    required String description,
    required List<String> genres,
    required int publishedYear,
    String? coverImage,
    int? pageCount,
    String? publisher,
    String? language,
  }) async {
    try {
      final response = await _apiService.post(
        '/books',
        body: {
          'title': title,
          'author': author,
          'isbn': isbn,
          'description': description,
          'genres': genres,
          'publishedYear': publishedYear,
          if (coverImage != null) 'coverImage': coverImage,
          if (pageCount != null) 'pageCount': pageCount,
          if (publisher != null) 'publisher': publisher,
          if (language != null) 'language': language,
        },
      );
      return BookModel.fromJson(response['data']);
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<BookModel> updateBook({
    required String bookId,
    String? title,
    String? author,
    String? isbn,
    String? description,
    List<String>? genres,
    int? publishedYear,
    String? coverImage,
    int? pageCount,
    String? publisher,
    String? language,
  }) async {
    try {
      final response = await _apiService.patch(
        '/books/$bookId',
        body: {
          if (title != null) 'title': title,
          if (author != null) 'author': author,
          if (isbn != null) 'isbn': isbn,
          if (description != null) 'description': description,
          if (genres != null) 'genres': genres,
          if (publishedYear != null) 'publishedYear': publishedYear,
          if (coverImage != null) 'coverImage': coverImage,
          if (pageCount != null) 'pageCount': pageCount,
          if (publisher != null) 'publisher': publisher,
          if (language != null) 'language': language,
        },
      );
      return BookModel.fromJson(response['data']);
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _apiService.delete('/books/$bookId');
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  // Review Management
  Future<List<ReviewModel>> getBookReviews({
    required String bookId,
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      };

      final response = await _apiService.get(
        '/books/$bookId/reviews?${Uri(queryParameters: queryParams).query}',
      );

      return (response['data'] as List)
          .map((review) => ReviewModel.fromJson(review))
          .toList();
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<ReviewModel> addReview({
    required String bookId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await _apiService.post(
        '/books/$bookId/reviews',
        body: {
          'rating': rating,
          'comment': comment,
        },
      );
      return ReviewModel.fromJson(response['data']);
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<ReviewModel> updateReview({
    required String bookId,
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    try {
      final response = await _apiService.patch(
        '/books/$bookId/reviews/$reviewId',
        body: {
          if (rating != null) 'rating': rating,
          if (comment != null) 'comment': comment,
        },
      );
      return ReviewModel.fromJson(response['data']);
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<void> deleteReview({
    required String bookId,
    required String reviewId,
  }) async {
    try {
      await _apiService.delete('/books/$bookId/reviews/$reviewId');
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  // Trade Management
  Future<List<TradeRequestModel>> getBookTrades({
    required String bookId,
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
      };

      final response = await _apiService.get(
        '/books/$bookId/trades?${Uri(queryParameters: queryParams).query}',
      );

      return (response['data'] as List)
          .map((trade) => TradeRequestModel.fromJson(trade))
          .toList();
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<TradeRequestModel> createTradeRequest({
    required String bookId,
    required String offeredBookId,
    String? message,
  }) async {
    try {
      final response = await _apiService.post(
        '/books/$bookId/trades',
        body: {
          'offeredBookId': offeredBookId,
          if (message != null) 'message': message,
        },
      );
      return TradeRequestModel.fromJson(response['data']);
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<TradeRequestModel> updateTradeStatus({
    required String bookId,
    required String tradeId,
    required String status,
    String? rejectionReason,
  }) async {
    try {
      final response = await _apiService.patch(
        '/books/$bookId/trades/$tradeId',
        body: {
          'status': status,
          if (rejectionReason != null) 'rejectionReason': rejectionReason,
        },
      );
      return TradeRequestModel.fromJson(response['data']);
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<void> cancelTrade({
    required String bookId,
    required String tradeId,
  }) async {
    try {
      await _apiService.delete('/books/$bookId/trades/$tradeId');
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  // Book Recommendations
  Future<List<BookModel>> getRecommendedBooks({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get(
        '/books/recommendations?${Uri(queryParameters: queryParams).query}',
      );

      return (response['data'] as List)
          .map((book) => BookModel.fromJson(book))
          .toList();
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  Future<List<BookModel>> getSimilarBooks({
    required String bookId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get(
        '/books/$bookId/similar?${Uri(queryParameters: queryParams).query}',
      );

      return (response['data'] as List)
          .map((book) => BookModel.fromJson(book))
          .toList();
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  // Book Statistics
  Future<Map<String, dynamic>> getBookStatistics(String bookId) async {
    try {
      final response = await _apiService.get('/books/$bookId/statistics');
      return response['data'];
    } catch (e) {
      throw _handleBookError(e);
    }
  }

  // Error Handling
  String _handleBookError(dynamic error) {
    if (error is ApiException) {
      switch (error.statusCode) {
        case 400:
          return 'Invalid book data provided.';
        case 401:
          return 'Authentication required.';
        case 403:
          return 'You do not have permission to perform this action.';
        case 404:
          return 'Book not found.';
        case 409:
          return 'A trade request already exists for this book.';
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