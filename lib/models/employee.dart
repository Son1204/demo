import 'dart:convert';

class Employee {
  final int? id;
  final String name;
  int wage;
  int wageOld;
  final String description;
  int daThanhToan;
  int chuaThanhToan;
  int tongTienChuaThanhToan;
  String dateUpLevel; // su dung filter
  final int? tongThuNhap;
  // List<int> chamCongNgay;

// Creating the setter method
  // to set the input in Field/Property
  // set setChamCongNgay(var ngayCong) {
  //   chamCongNgay = ngayCong;
  // }

  Employee(
      {this.id,
      required this.name,
      this.wage = 0,
      required this.description,
      // required this.chamCongNgay,
      this.daThanhToan = 0,
      this.chuaThanhToan = 0,
      this.tongTienChuaThanhToan = 0,
      this.tongThuNhap,
      this.wageOld = 0,
      this.dateUpLevel = '',
      });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'wage': wage,
      'description': description,
      'tongThuNhap': tongThuNhap,
      'chuaThanhToan': chuaThanhToan,
      'tongTienChuaThanhToan': tongTienChuaThanhToan,
      'daThanhToan': daThanhToan,
      'wageOld': wageOld,
      'dateUpLevel': dateUpLevel,
      // 'chamCongNgay': json.encode(chamCongNgay)
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    print("(formMap)" + map.toString());
    return Employee(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      wage: map['wage']?.toInt() ?? 0,
      description: map['description'] ?? '',
      tongThuNhap: map['tongThuNhap']?.toInt() ?? 0,
      chuaThanhToan: map['chuaThanhToan']?.toInt() ?? 0,
      tongTienChuaThanhToan: map['tongTienChuaThanhToan']?.toInt() ?? 0,
      daThanhToan: map['daThanhToan']?.toInt() ?? 0,
      wageOld: map['wageOld']?.toInt() ?? 0,
      dateUpLevel: map['dateUpLevel'],
      // chamCongNgay: json.decode(map['chamCongNgay']).cast<int>()
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) =>
      Employee.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'Employee(id: $id, name: $name, wage: $wage, wageOld: $wageOld, description: $description, chuaThanhToan: $chuaThanhToan, tongTienChuaThanhToan: $tongTienChuaThanhToan)';
}
