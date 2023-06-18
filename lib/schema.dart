part of mongo_database;

class Property {
  final bool isIndex;
  final bool isUnique;
  final String? Function(dynamic value)? validator;
  final dynamic defaultValue;

  const Property({
    this.isIndex = false,
    this.isUnique = false,
    this.validator,
    this.defaultValue,
  });
}

class Schema {
  final Map<String, Property> properties;

  Schema({
    required this.properties,
  });

  String? validate(Map<String, dynamic> data) {
    for (final entry in properties.entries) {
      final validator = entry.value.validator;
      if (validator == null) continue;
      final value = data[entry.key];
      final error = validator(value);
      if (error != null) return "${entry.key}: $error";
    }
    return null;
  }
}
