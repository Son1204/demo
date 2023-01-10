import 'dart:convert';

class Log {
  final int? id;
  final String description;
  final String descriptionOfUser;
  final int day;
  final int month;
  final int year;
  final String date; // dung de filter
  final String dateTime; // thoi gian log
  final String dataJson;
  final int soTien;
  String employeeName;
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
    required this.descriptionOfUser,
    required this.date,
    required this.dataJson,
    required this.employeeId,
    required this.dateTime,
    this.employeeName = '',
    this.soTien = 0,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'month': month,
      'description1': description,
      'year': year,
      'date': date,
      'dataJson': dataJson,
      'employeeId': employeeId,
      'dateTime': dateTime,
      'soTien': soTien,
      'descriptionOfUser': descriptionOfUser
      // 'chamCongNgay': json.encode(chamCongNgay)
    };
  }

  factory Log.fromMap(Map<String, dynamic> map) {
    print("(formMap)" + map.toString());
    return Log(
      id: map['id']?.toInt() ?? 0,
      day: map['day'] ?? '',
      month: map['month']?.toInt() ?? 0,
      description: map['description1'] ?? '',
      year: map['year']?.toInt() ?? 0,
      date: map['date'],
      dataJson: json.decode(map['dataJson']),
      employeeId: map['employeeId']?.toInt() ?? 0,
      dateTime: map['dateTime'],
      employeeName: map['name'] ?? '',
        soTien: map['soTien']?.toInt() ?? 0,
        descriptionOfUser: map['descriptionOfUser']
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
      'Log(id: $id, date: $date,dateView: $dateTime, employeeId: $employeeId, description: $description, data: $dataJson)';
}
