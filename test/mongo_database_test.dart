import 'package:flutter_test/flutter_test.dart';

import 'package:mongo_database/mongo_database.dart';

class PatientRecord {
  final String firstName;
  final String lastName;
  final String phoneNumber;

  const PatientRecord({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  factory PatientRecord.fromMap(Map<String, dynamic> map) {
    return PatientRecord(
      firstName: map["first_name"] as String,
      lastName: map["last_name"] as String,
      phoneNumber: map["phone_number"] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
    };
  }
}

void main() {
  final client = Client(
    host: "frankfurt.tbmui0y.mongodb.net",
    username: "0L04IaQ8afh67pxI",
    password: "TpaTkuB2tgU13mKZ",
  );

  test('adds one to input values', () async {
    final database = await client.database("test_database");
    final model = await database.createModel(
      collection: "patient_records",
      formatter: Formatter(
        fromDatabase: (data) {
          return PatientRecord.fromMap(data);
        },
        toDatabase: (data) {
          return data.toMap();
        },
      ),
      schema: Schema(
        properties: {
          "first_name": const Property(),
          "last_name": const Property(),
          "phone_number": Property(
            validator: (value) {
              if (value == null) return "Required";
              if (value.length != 11 || !value.startsWith("09")) return "Invalid";
              return null;
            },
          ),
        },
      ),
    );
    final document = await model.create(const PatientRecord(
      firstName: "Ehsan",
      lastName: "Rashidi",
      phoneNumber: "09335283181",
    ));
    await Future.delayed(const Duration(seconds: 3));
    document.setData(const PatientRecord(
      firstName: "Baran",
      lastName: "Rashidi",
      phoneNumber: "09335283181",
    ));
    await document.save();
  });
}
