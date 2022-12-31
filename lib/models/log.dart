import 'dart:convert';

class Log {
  final int? id;
  final String description;
  final int day;
  final int month;
  final int year;
  final String date;
  final String dataJson;
  int employeeId;
  // List<int> chamCongNgay;

// Creating the setter method
  // to set the input in Field/Property
  // set setChamCongNgay(var ngayCong) {
  //   chamCongNgay = ngayCong;
  // }

  Log({
    this.id,
    required this.day,
    required this.month,
    required this.year,
    required this.description,
    required this.date,
    required this.dataJson,
    required this.employeeId,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'month': month,
      'description': description,
      'year': year,
      'date': date,
      'dataJson': dataJson,
      'employeeId': employeeId,
      // 'chamCongNgay': json.encode(chamCongNgay)
    };
  }

  factory Log.fromMap(Map<String, dynamic> map) {
    print("(formMap)" + map.toString());
    return Log(
      id: map['id']?.toInt() ?? 0,
      day: map['day'] ?? '',
      month: map['month']?.toInt() ?? 0,
      description: map['description'] ?? '',
      year: map['year']?.toInt() ?? 0,
      date: map['date'],
      dataJson: json.decode(map['dataJson']),
      employeeId: map['employeeId']?.toInt() ?? 0,
      // chamCongNgay: json.decode(map['chamCongNgay']).cast<int>()
    );
  }

  String toJson() => json.encode(toMap());

  factory Log.fromJson(String source) =>
      Log.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'Log(id: $id, date: $date, employeeId: $employeeId, description: $description, data: $dataJson)';
}
