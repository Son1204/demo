import 'dart:convert';

class UpLevel {
  final int? id;
  final int wageOld;
  final int wageNew;
  final int day;
  final int month;
  final int year;
  final int employeeId;
  final String description;
  // List<int> chamCongNgay;

// Creating the setter method
  // to set the input in Field/Property
  // set setChamCongNgay(var ngayCong) {
  //   chamCongNgay = ngayCong;
  // }

  UpLevel( {
    this.id,
    required this.wageOld,
    required this.wageNew,
    required this.description,
    required this.employeeId, required this.day, required this.month, required this.year
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wageNew': wageNew,
      'description': description,
      'day': day,
      'month': month,
      'year': year,
      'employeeId': employeeId,
      'wageOld': wageOld,
      // 'chamCongNgay': json.encode(chamCongNgay)
    };
  }

  factory UpLevel.fromMap(Map<String, dynamic> map) {
    print("(formMap)"+map.toString());
    return UpLevel(
      id: map['id']?.toInt() ?? 0,
      wageOld: map['wageOld']?.toInt() ?? 0,
      day: map['day']?.toInt() ?? 0,
      description: map['description'] ?? '',
      month: map['month']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
      employeeId: map['employeeId']?.toInt() ?? 0,
      wageNew: map['wageNew']?.toInt() ?? 0,
      // chamCongNgay: json.decode(map['chamCongNgay']).cast<int>()
    );
  }

  String toJson() => json.encode(toMap());

  factory UpLevel.fromJson(String source) => UpLevel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'UpLevel(id: $id, wageOld: $wageOld, employeeId: $employeeId, wageNew: $wageNew)';
}
