import 'dart:convert';

class EmployeeEnrich {
  final int? id;
  final String name;
  final int? wage;
  final String description;
  final int? daThanhToan;
  final int? chuaThanhToan;
  final int? tongThuNhap;
  List<int> chamCongNgay;
  final int thuNhapThucTe;
  final int? totalOfMonth;

// Creating the setter method
  // to set the input in Field/Property
  // set setChamCongNgay(var ngayCong) {
  //   chamCongNgay = ngayCong;
  // }

  EmployeeEnrich({
    this.id,
    required this.name,
    this.wage,
    required this.description,
    required this.chamCongNgay,
    this.daThanhToan,
    this.chuaThanhToan,
    this.tongThuNhap,
    required this.thuNhapThucTe,
    this.totalOfMonth
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
      'daThanhToan': daThanhToan,
      'chamCongNgay': json.encode(chamCongNgay),
      'thuNhapThucTe': thuNhapThucTe
    };
  }

  factory EmployeeEnrich.fromMap(Map<String, dynamic> map) {
    print("(formMap)"+map.toString());
    return EmployeeEnrich(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      wage: map['wage']?.toInt() ?? 0,
      description: map['description'] ?? '',
      tongThuNhap: map['tongThuNhap']?.toInt() ?? 0,
      chuaThanhToan: map['chuaThanhToan']?.toInt() ?? 0,
      daThanhToan: map['daThanhToan']?.toInt() ?? 0,
      chamCongNgay: json.decode(map['chamCongNgay']).cast<int>(),
        thuNhapThucTe: map['thuNhapThucTe']?.toInt() ?? 0,
        totalOfMonth: map['totalOfMonth']?.toInt() ?? 0
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeEnrich.fromJson(String source) => EmployeeEnrich.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'EmployeeEnrich(id: $id, name: $name, wage: $wage, description: $description)';
}
