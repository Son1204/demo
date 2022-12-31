import 'dart:convert';

class KyCong {
  final int? id;
  final String title;
  final int employeeId;
  final int month;
  final int year;

  final int? ngayTinhCong; // 20221227
  final int? soNgayCongTrongThang;

  final int? totalOfMonth;
  final int? daThanhToanThang;
  final int? chuaThanhToanThang;
  final String? note;

  KyCong({
    this.id,
    required this.title,
    required this.month,
    required this.year,
    this.ngayTinhCong,
    this.soNgayCongTrongThang,
    this.note,
    required this.employeeId,
    this.totalOfMonth,
    this.daThanhToanThang,
    this.chuaThanhToanThang,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'month': month,
      'year': year,
      'employeeId': employeeId,
      'ngayTinhCong': ngayTinhCong,
      'soNgayCongTrongThang': soNgayCongTrongThang,
      'note': note,
      'totalOfMonth': totalOfMonth,
      'daThanhToanThang': daThanhToanThang,
      'chuaThanhToanThang': chuaThanhToanThang
    };
  }

  factory KyCong.fromMap(Map<String, dynamic> map) {
    return KyCong(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      month: map['month']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
      ngayTinhCong: map['ngayTinhCong']?.toInt() ?? 0,
      soNgayCongTrongThang: map['soNgayCongTrongThang']?.toInt() ?? 0,
      note: map['note'],
        employeeId: map['employeeId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory KyCong.fromJson(String source) => KyCong.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'KyCong(id: $id, title: $title, employeeId: $employeeId)';
}
