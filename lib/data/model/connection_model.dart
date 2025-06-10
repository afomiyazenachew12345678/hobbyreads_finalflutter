import 'package:hobby_reads_flutter/data/model/auth_model.dart';

class ConnectionModel {
  final String id;
  final AuthModel user;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? catchPhrase;
  final List<String>? sharedInterests;
  final Map<String, dynamic>? metadata;

  ConnectionModel({
    required this.id,
    required this.user,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.catchPhrase,
    this.sharedInterests,
    this.metadata,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    try {
      return ConnectionModel(
        id: json['id'],
        user: AuthModel.fromJson(json['user']),
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
        catchPhrase: json['catchPhrase'],
        sharedInterests: json['sharedInterests'] != null
            ? List<String>.from(json['sharedInterests'])
            : null,
        metadata: json['metadata'],
      );
    } catch (e) {
      throw FormatException('Failed to parse ConnectionModel from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'id': id,
        'user': user.toJson(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'catchPhrase': catchPhrase,
        'sharedInterests': sharedInterests,
        'metadata': metadata,
      };
    } catch (e) {
      throw FormatException('Failed to convert ConnectionModel to JSON: $e');
    }
  }

  ConnectionModel copyWith({
    String? id,
    AuthModel? user,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? catchPhrase,
    List<String>? sharedInterests,
    Map<String, dynamic>? metadata,
  }) {
    try {
      return ConnectionModel(
        id: id ?? this.id,
        user: user ?? this.user,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        catchPhrase: catchPhrase ?? this.catchPhrase,
        sharedInterests: sharedInterests ?? this.sharedInterests,
        metadata: metadata ?? this.metadata,
      );
    } catch (e) {
      throw FormatException('Failed to create copy of ConnectionModel: $e');
    }
  }

  @override
  String toString() {
    return 'ConnectionModel(id: $id, user: $user, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, catchPhrase: $catchPhrase, sharedInterests: $sharedInterests, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConnectionModel &&
        other.id == id &&
        other.user == user &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.catchPhrase == catchPhrase &&
        other.sharedInterests == sharedInterests &&
        other.metadata == metadata;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      user,
      status,
      createdAt,
      updatedAt,
      catchPhrase,
      sharedInterests,
      metadata,
    );
  }
}