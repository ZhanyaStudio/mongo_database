part of mongo_database;

class Client {
  final String host;
  final String username;
  final String password;

  Client({
    required this.host,
    required this.username,
    required this.password,
  });

  Future<Db> database(String database) async {
    final url = "mongodb+srv://$username:$password@$host/$database?retryWrites=true&w=majority";
    final db = await Db.create(url);
    await db.open();
    return db;
  }
}
