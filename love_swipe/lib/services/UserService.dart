import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:mysql1/mysql1.dart';

import '../models/UserModel.dart';
import 'Database.dart';

class UserService {
  final Database _db = Database();

  Future<UserModel?> getUserByEmail(String email) async {
    MySqlConnection connection = await _db.connect();
    var result = await connection.query('''
    SELECT * FROM users WHERE email = ?
  ''', [
      email,
    ]);

    await _db.close(connection);

    if (result.isNotEmpty) {
      var row = result.first;
      return UserModel(
        id: row['id'],
        username: row['username'],
        password: row['password'],
        email: row['email'],
        profilePhoto: row['profile_photo'],
        biography: row['biography'],
        createdAt: row['created_at'],
        updatedAt: row['updated_at'],
      );
    }
    return null;
  }

  Future<void> addUser(String username, String password, String email,
      {String profilePhoto = '', String biography = ''}) async {
    MySqlConnection connection = await _db.connect();

    String hashedPassword = hashPassword(password); // Şifreyi hashle

    await connection.query('''
    INSERT INTO users (username, password, email, profile_photo, biography, created_at, updated_at)
    VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
  ''', [
      username,
      hashedPassword,
      email,
      profilePhoto,
      biography,
    ]);

    await _db.close(connection);
  }

  Future<bool> verifyUser(String email, String password) async {
    MySqlConnection connection = await _db.connect();
    print("connection");
    String hashedPassword = hashPassword(password); // Girilen şifreyi hashle

    var result = await connection.query('''
    SELECT * FROM users WHERE email = ? AND password = ?
  ''', [
      email,
      hashedPassword,
    ]);

    await _db.close(connection);

    return result.isNotEmpty;
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Şifreyi byte dizisine çevirin
    var digest = sha256.convert(bytes); // SHA-256 hash işlemi
    return digest.toString(); // Hashlenmiş şifreyi string olarak döndürün
  }

  Future<void> updateUser(int userId, String newUsername, String newEmail,
      String newBiography) async {
    MySqlConnection connection = await _db.connect();

    await connection.query('''
    UPDATE users
    SET username = ?, email = ?, biography = ?, updated_at = CURRENT_TIMESTAMP
    WHERE id = ?
  ''', [
      newUsername,
      newEmail,
      newBiography,
      userId,
    ]);

    await _db.close(connection);
  }

  Future<void> updateUsername(int userId, String newUsername) async {
    MySqlConnection connection = await _db.connect();

    await connection.query('''
    UPDATE users SET username = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?
  ''', [
      newUsername,
      userId,
    ]);

    await _db.close(connection);
  }

  Future<void> updateProfilePhoto(int userId, String newProfilePhoto) async {
    MySqlConnection connection = await _db.connect();

    await connection.query('''
    UPDATE users SET profile_photo = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?
  ''', [
      newProfilePhoto,
      userId,
    ]);

    await _db.close(connection);
  }

  Future<void> updateEmail(int userId, String newEmail) async {
    MySqlConnection connection = await _db.connect();

    await connection.query('''
    UPDATE users SET email = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?
  ''', [
      newEmail,
      userId,
    ]);

    await _db.close(connection);
  }

  Future<void> updateBiography(int userId, String newBiography) async {
    MySqlConnection connection = await _db.connect();

    await connection.query('''
    UPDATE users SET biography = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?
  ''', [
      newBiography,
      userId,
    ]);

    await _db.close(connection);
  }

  Future<List<UserModel>> getRandomUser({int limit = 1}) async {
    MySqlConnection connection = await _db.connect();

    var result = await connection.query('''
    SELECT * FROM users WHERE isBot = ? ORDER BY RAND() LIMIT ?
  ''', [0, limit]);

    await _db.close(connection);
    List<UserModel> userModels = [];
    if (result.isNotEmpty) {
      for (var row in result) {
        // Her bir `row` için döngüyü başlatın
        userModels.add(UserModel(
          id: row['id'],
          username: row['username'],
          password: row['password'],
          email: row['email'],
          profilePhoto: row['profile_photo'],
          biography: row['biography'],
          createdAt: row['created_at'],
          updatedAt: row['updated_at'],
        ));
      }
    }
    return userModels;
  }
}
