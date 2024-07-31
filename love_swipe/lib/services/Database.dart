import 'package:mysql1/mysql1.dart';

class Database {

  Future<MySqlConnection> _initializeConnection() async {
    String host = '185.246.113.234';
    int port = 3306;
    String user = 'lexyiswin';
    String password = 'D2vzdgShP3)v*h2S';
    String db = 'love-swipe';
    MySqlConnection connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
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
