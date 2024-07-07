class UserModel {
   int id;
   String username;
   String password;
   String email;
   String? profilePhoto;
   String biography;
   DateTime createdAt;
   DateTime updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.profilePhoto,
    required this.biography,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      profilePhoto: json['profile_photo'],
      biography: json['biography'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'profile_photo': profilePhoto,
      'biography': biography,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
