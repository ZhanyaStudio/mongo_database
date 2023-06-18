part of mongo_database;

class Document<T> {
  final Model _model;
  final Formatter<T> _formatter;

  var _data = <String, dynamic>{};

  Document({
    required Model model,
    required Map<String, dynamic> data,
    required Formatter<T> formatter,
  })  : _model = model,
        _data = data,
        _formatter = formatter;

  ObjectId get id {
    return _data["_id"];
  }

  DateTime get createdAt {
    final value = _data["created_at"] as int;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  DateTime get updatedAt {
    final value = _data["updated_at"] as int;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> delete() {
    return _model._collection.deleteOne({"_id": id});
  }

  Future<void> save() {
    final error = _model._schema.validate(_data);
    if (error != null) throw Exception(error);

    _data["updated_at"] = DateTime.now().millisecondsSinceEpoch;

    final copy = Map<String, dynamic>.from(_data)..remove("_id");
    return _model._collection.replaceOne({"_id": id}, copy);
  }

  @override
  operator ==(Object? other) {
    return other is Document && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  T getData() {
    return _formatter.fromDatabase(_data);
  }

  void setData(T data) {
    _data = _formatter.toDatabase(data);
  }
}
