class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? bio;
  final String? profilePicture;
  final List<String>? hobbies;
  final Map<String, dynamic>? preferences;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final Map<String, bool>? notificationSettings;
  final Map<String, bool>? privacySettings;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.bio,
    this.profilePicture,
    this.hobbies,
    this.preferences,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.notificationSettings,
    this.privacySettings,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      bio: json['bio'] as String?,
      profilePicture: json['profilePicture'] as String?,
      hobbies: (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      preferences: json['preferences'] as Map<String, dynamic>?,
      isEmailVerified: json['isEmailVerified'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool,
      notificationSettings: (json['notificationSettings'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as bool),
      ),
      privacySettings: (json['privacySettings'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as bool),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'bio': bio,
      'profilePicture': profilePicture,
      'hobbies': hobbies,
      'preferences': preferences,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'notificationSettings': notificationSettings,
      'privacySettings': privacySettings,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? bio,
    String? profilePicture,
    List<String>? hobbies,
    Map<String, dynamic>? preferences,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, bool>? notificationSettings,
    Map<String, bool>? privacySettings,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      profilePicture: profilePicture ?? this.profilePicture,
      hobbies: hobbies ?? this.hobbies,
      preferences: preferences ?? this.preferences,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }
} 