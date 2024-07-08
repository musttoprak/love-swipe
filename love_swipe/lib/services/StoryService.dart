import 'package:mysql1/mysql1.dart';
import '../models/StoryModel.dart';
import '../models/UserModel.dart'; // Import your UserModel
import 'Database.dart';

class StoryService {
  final Database _db = Database();

  Future<void> addStory(StoryModel story) async {
    MySqlConnection connection = await _db.connect();

    await connection.query('''
    INSERT INTO stories (user_id, photo_url, created_at, updated_at)
    VALUES (?, ?, ?, ?)
  ''', [
      story.user.id,
      story.photoUrl,
      story.createdAt.toIso8601String(),
      story.updatedAt.toIso8601String(),
    ]);

    await _db.close(connection);
  }

  Future<StoryModel?> getStoryById(int id) async {
    MySqlConnection connection = await _db.connect();
    var result = await connection.query('SELECT * FROM stories WHERE id = ?', [id]);

    await _db.close(connection);

    if (result.isNotEmpty) {
      var row = result.first;
      var user = await _getUserById(row['user_id']); // Fetch user details
      return StoryModel(
        id: row['id'],
        user: user!,
        photoUrl: row['photo_url'],
        createdAt: row['created_at'],
        updatedAt: row['updated_at'],
      );
    }
    return null;
  }

  Future<UserModel?> _getUserById(int userId) async {
    MySqlConnection connection = await _db.connect();
    var result = await connection.query('SELECT * FROM users WHERE id = ?', [userId]);

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

  Future<void> updateStory(StoryModel story) async {
    MySqlConnection connection = await _db.connect();

    await connection.query('''
    UPDATE stories SET user_id = ?, photo_url = ?, created_at = ?, updated_at = ?
    WHERE id = ?
  ''', [
      story.user.id,
      story.photoUrl,
      story.createdAt.toIso8601String(),
      story.updatedAt.toIso8601String(),
      story.id,
    ]);

    await _db.close(connection);
  }

  Future<void> deleteStory(int id) async {
    MySqlConnection connection = await _db.connect();

    await connection.query('DELETE FROM stories WHERE id = ?', [id]);

    await _db.close(connection);
  }

  Future<List<StoryModel>> getAllStories() async {
    MySqlConnection connection = await _db.connect();
    var result = await connection.query('SELECT * FROM stories');

    await _db.close(connection);

    List<StoryModel> stories = [];
    for (var row in result) {
      var user = await _getUserById(row['user_id']); // Fetch user details
      stories.add(StoryModel(
        id: row['id'],
        user: user!,
        photoUrl: row['photo_url'],
        createdAt: row['created_at'],
        updatedAt: row['updated_at'],
      ));
    }
    return stories;
  }

  Future<List<StoryModel>> getPaginatedStories(int pageSize, int page) async {
    MySqlConnection connection = await _db.connect();
    int offset = (page - 1) * pageSize; // Calculate offset based on page number

    var result = await connection.query('SELECT * FROM stories LIMIT ? OFFSET ?', [pageSize, offset]);

    await _db.close(connection);

    List<StoryModel> stories = [];
    for (var row in result) {
      var user = await _getUserById(row['user_id']);
      stories.add(StoryModel(
        id: row['id'],
        user: user!,
        photoUrl: row['photo_url'],
        createdAt: row['created_at'],
        updatedAt: row['updated_at'],
      ));
    }
    return stories;
  }

  Future<List<StoryModel>> getRandomUser({int limit = 1}) async {
    MySqlConnection connection = await _db.connect();

    var result = await connection.query('''
    SELECT * FROM stories ORDER BY RAND() LIMIT ?
  ''', [
      limit,
    ]);

    await _db.close(connection);
    List<StoryModel> stories = [];
    for (var row in result) {
      var user = await _getUserById(row['user_id']);
      stories.add(StoryModel(
        id: row['id'],
        user: user!,
        photoUrl: row['photo_url'],
        createdAt: row['created_at'],
        updatedAt: row['updated_at'],
      ));
    }
    return stories;
  }
}
