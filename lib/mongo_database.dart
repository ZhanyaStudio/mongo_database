library mongo_database;

import "package:mongo_dart/mongo_dart.dart";

part "model.dart";
part "client.dart";
part "schema.dart";
part "document.dart";
part "formatter.dart";

extension DbExtension on Db {
  Future<Model<T>> createModel<T>({
    required String collection,
    required Schema schema,
    required Formatter<T> formatter,
  }) async {
    await createCollection(collection);

    final futures = <Future>[];
    for (final property in schema.properties.entries) {
      if (property.value.isIndex) {
        futures.add(createIndex(
          collection,
          unique: property.value.isUnique,
          key: property.key,
        ));
      } else if (property.value.isUnique) {
        futures.add(createIndex(
          collection,
          unique: true,
          key: property.key,
        ));
      }
    }

    await Future.wait(futures);

    return Model(
      schema: schema,
      formatter: formatter,
      collection: this.collection(collection),
    );
  }
}
