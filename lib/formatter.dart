part of mongo_database;

class Formatter<T> {
  final T Function(Map<String, dynamic> data) fromDatabase;
  final Map<String, dynamic> Function(T data) toDatabase;

  const Formatter({
    required this.fromDatabase,
    required this.toDatabase,
  });
}
