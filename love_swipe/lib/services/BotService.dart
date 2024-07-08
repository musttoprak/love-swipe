import 'package:mysql1/mysql1.dart';
import '../models/StoryModel.dart';
import '../models/UserModel.dart'; // Import your UserModel
import 'Database.dart';

class BotService {
  final Database _db = Database();

  Future<List<String>> getRandomUsers({int limit = 7}) async {
    MySqlConnection connection = await _db.connect();

    var result = await connection.query('''
    SELECT * FROM bot_users ORDER BY RAND() LIMIT ?
  ''', [
      limit,
    ]);

    await _db.close(connection);
    List<String> users = [];
    for (var row in result) {
      users.add(row['tag']);
    }
    return users;
  }

  Future<List<String>> getRandomMessages({int limit = 7}) async {
    MySqlConnection connection = await _db.connect();

    var result = await connection.query('''
    SELECT * FROM bot_messages ORDER BY RAND() LIMIT ?
  ''', [
      limit,
    ]);

    await _db.close(connection);
    List<String> messages = [];
    for (var row in result) {
      messages.add(row['tag']);
    }
    return messages;
  }

  Future<List<String>> getRandomImages({int limit = 7}) async {
    MySqlConnection connection = await _db.connect();

    var result = await connection.query('''
    SELECT * FROM bot_images ORDER BY RAND() LIMIT ?
  ''', [
      limit,
    ]);

    await _db.close(connection);
    List<String> images = [];
    for (var row in result) {
      images.add(row['url']);
    }
    return images;
  }
}
