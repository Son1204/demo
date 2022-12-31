import 'dart:convert';

class Bill {
  final int? id;
  final int soTien;
  final int employeeId;
  final int day;
  final int month;
  final int year;
  final String date;
  final String description;
  // List<int> chamCongNgay;

// Creating the setter method
  // to set the input in Field/Property
  // set setChamCongNgay(var ngayCong) {
  //   chamCongNgay = ngayCong;
  // }

  Bill( {
    this.id,
    required this.soTien,
    required this.description,
    required this.employeeId, required this.day, required this.month, required this.year, required this.date,
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
      // 'chamCongNgay': json.encode(chamCongNgay)
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    print("(formMap)"+map.toString());
    return Bill(
      id: map['id']?.toInt() ?? 0,
      soTien: map['soTien'] ?? '',
      day: map['day']?.toInt() ?? 0,
      description: map['description'] ?? '',
      month: map['month']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
      employeeId: map['employeeId']?.toInt() ?? 0,
      date: map['date'],
      // chamCongNgay: json.decode(map['chamCongNgay']).cast<int>()
    );
  }

  String toJson() => json.encode(toMap());

  factory Bill.fromJson(String source) => Bill.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Bill(id: $id, soTien: $soTien, employeeId: $employeeId, description: $description)';
}
