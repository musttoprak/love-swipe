import 'package:mysql1/mysql1.dart';

class Database {

  Future<MySqlConnection> _initializeConnection() async {
    String host = '10.0.2.2';
    int port = 3306; 
    String user = 'root';
    String password = '';
    String db = 'love-swipe';
    MySqlConnection connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: host,
        port: port,
        user: user,
        db: db,
      ),
    );

    return connection;
  }

  Future<MySqlConnection> connect() async {
    return _initializeConnection();
  }

  Future<void> close(MySqlConnection connection) async {
    await connection.close();
    print('Bağlantı kapatıldı');
  }
}
