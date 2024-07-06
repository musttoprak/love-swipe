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

  Future<bool> verifyUser(String username, String password) async {
    MySqlConnection connection = await _db.connect();
    print("connection");
    String hashedPassword = hashPassword(password); // Girilen şifreyi hashle

    var result = await connection.query('''
    SELECT * FROM users WHERE username = ? AND password = ?
  ''', [
      username,
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
}
