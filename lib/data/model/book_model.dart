

class BookModel {
  final String id;
  final String title;
  final String author;
  final String? coverImage;
  final String description;
  final double rating;
  final List<String> genres;
  final int pageCount;
  final String? isbn;
  final DateTime publishedDate;
  final String? publisher;
  final List<Review> reviews;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    this.coverImage,
    required this.description,
    required this.rating,
    required this.genres,
    required this.pageCount,
    this.isbn,
    required this.publishedDate,
    this.publisher,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy of the model with some fields updated
  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? coverImage,
    String? description,
    double? rating,
    List<String>? genres,
    int? pageCount,
    String? isbn,
    DateTime? publishedDate,
    String? publisher,
    List<Review>? reviews,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverImage: coverImage ?? this.coverImage,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      genres: genres ?? this.genres,
      pageCount: pageCount ?? this.pageCount,
      isbn: isbn ?? this.isbn,
      publishedDate: publishedDate ?? this.publishedDate,
      publisher: publisher ?? this.publisher,
      reviews: reviews ?? this.reviews,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverImage': coverImage,
      'description': description,
      'rating': rating,
      'genres': genres,
      'pageCount': pageCount,
      'isbn': isbn,
      'publishedDate': publishedDate.toIso8601String(),
      'publisher': publisher,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create model from JSON
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      coverImage: json['coverImage'] as String?,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      genres: List<String>.from(json['genres'] as List),
      pageCount: json['pageCount'] as int,
      isbn: json['isbn'] as String?,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      publisher: json['publisher'] as String?,
      reviews: (json['reviews'] as List)
          .map((review) => Review.fromJson(review as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Create an empty model
  factory BookModel.empty() {
    return BookModel(
      id: '',
      title: '',
      author: '',
      description: '',
      rating: 0.0,
      genres: [],
      pageCount: 0,
      publishedDate: DateTime.now(),
      reviews: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Check if the model is empty
  bool get isEmpty => id.isEmpty;

  // Check if the model is not empty
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return 'BookModel(id: $id, title: $title, author: $author, coverImage: $coverImage, description: $description, rating: $rating, genres: $genres, pageCount: $pageCount, isbn: $isbn, publishedDate: $publishedDate, publisher: $publisher, reviews: $reviews, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookModel &&
        other.id == id &&
        other.title == title &&
        other.author == author &&
        other.coverImage == coverImage &&
        other.description == description &&
        other.rating == rating &&
        other.genres == genres &&
        other.pageCount == pageCount &&
        other.isbn == isbn &&
        other.publishedDate == publishedDate &&
        other.publisher == publisher &&
        other.reviews == reviews &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      author,
      coverImage,
      description,
      rating,
      Object.hashAll(genres),
      pageCount,
      isbn,
      publishedDate,
      publisher,
      Object.hashAll(reviews),
      createdAt,
      updatedAt,
    );
  }
}

class Review {
  final String id;
  final String userId;
  final String username;
  final String handle;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.username,
    required this.handle,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy of the review with some fields updated
  Review copyWith({
    String? id,
    String? userId,
    String? username,
    String? handle,
    int? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      handle: handle ?? this.handle,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert review to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'handle': handle,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create review from JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      handle: json['handle'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Review(id: $id, userId: $userId, username: $username, handle: $handle, rating: $rating, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review &&
        other.id == id &&
        other.userId == userId &&
        other.username == username &&
        other.handle == handle &&
        other.rating == rating &&
        other.comment == comment &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      username,
      handle,
      rating,
      comment,
      createdAt,
      updatedAt,
    );
  }
} 