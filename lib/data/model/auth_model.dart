

class AuthModel {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final String? bio;
  final List<String> hobbies;
  final String? handle;
  final DateTime createdAt;
  final DateTime updatedAt;

  AuthModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.bio,
    required this.hobbies,
    this.handle,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy of the model with some fields updated
  AuthModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePicture,
    String? bio,
    List<String>? hobbies,
    String? handle,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      hobbies: hobbies ?? this.hobbies,
      handle: handle ?? this.handle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'bio': bio,
      'hobbies': hobbies,
      'handle': handle,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create model from JSON
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
      hobbies: List<String>.from(json['hobbies'] as List),
      handle: json['handle'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Create an empty model
  factory AuthModel.empty() {
    return AuthModel(
      id: '',
      name: '',
      email: '',
      hobbies: [],
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
    return 'AuthModel(id: $id, name: $name, email: $email, profilePicture: $profilePicture, bio: $bio, hobbies: $hobbies, handle: $handle, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profilePicture == profilePicture &&
        other.bio == bio &&
        other.hobbies == hobbies &&
        other.handle == handle &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      profilePicture,
      bio,
      Object.hashAll(hobbies),
      handle,
      createdAt,
      updatedAt,
    );
  }
} 