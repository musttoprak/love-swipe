import 'UserModel.dart';

class StoryModel {
  final int id;
  final UserModel user;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoryModel({
    required this.id,
    required this.user,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // For converting JSON data to a StoryModel instance
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      photoUrl: json['photo_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // For converting a StoryModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
