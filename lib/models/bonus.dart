import 'dart:convert';

class Bonus {
  final int? id;
  final int soTien;
  final int employeeId;
  final int day;
  final int month;
  final int year;
  final String date;
  final String description;
  final int daTraTien;
  // List<int> chamCongNgay;

// Creating the setter method
  // to set the input in Field/Property
  // set setChamCongNgay(var ngayCong) {
  //   chamCongNgay = ngayCong;
  // }

  Bonus( {
    this.id,
    required this.soTien,
    required this.description,
    required this.employeeId, required this.day, required this.month, required this.year, required this.date,
    this.daTraTien = 0
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'soTien': soTien,
      'description': description,
      'day': day,
      'month': month,
      'year': year,
      'employeeId': employeeId,
      'date': date,
      'daTraTien': daTraTien,
      // 'chamCongNgay': json.encode(chamCongNgay)
    };
  }

  factory Bonus.fromMap(Map<String, dynamic> map) {
    print("(formMap)"+map.toString());
    return Bonus(
      id: map['id']?.toInt() ?? 0,
      soTien: map['soTien'] ?? '',
      day: map['day']?.toInt() ?? 0,
      description: map['description'] ?? '',
      month: map['month']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
      employeeId: map['employeeId']?.toInt() ?? 0,
      date: map['date'],
      daTraTien: map['daTraTien']?.toInt() ?? 0,
      // chamCongNgay: json.decode(map['chamCongNgay']).cast<int>()
    );
  }

  String toJson() => json.encode(toMap());

  factory Bonus.fromJson(String source) => Bonus.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Bonus(id: $id, soTien: $soTien, employeeId: $employeeId, description: $description)';
}
