part of mongo_database;

class Model<T> {
  final Schema _schema;
  final DbCollection _collection;
  final Formatter<T> _formatter;

  const Model({
    required Schema schema,
    required DbCollection collection,
    required Formatter<T> formatter,
  })  : _schema = schema,
        _collection = collection,
        _formatter = formatter;

  Future<Document<T>> create(T data) async {
    final formatted = _formatter.toDatabase(data);

    final error = _schema.validate(formatted);
    if (error != null) throw Exception(error);

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final result = await _collection.insertOne({
      "created_at": timestamp,
      "updated_at": timestamp,
      ...formatted,
    });

    return Document<T>(
      model: this,
      formatter: _formatter,
      data: result.document as Map<String, dynamic>,
    );
  }
}
