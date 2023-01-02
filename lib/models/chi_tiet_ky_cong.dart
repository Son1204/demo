import 'dart:convert';

class ChiTietKyCong {
  final int? id;
  final String title;
  final int kyCongId;
  final int day;
  final String date;
  int thuNhapThucTe;
  List<int> chamCongNgay;
  // final String? d1;
  // final String? d2;
  // final String? d3;
  // final String? d4;
  // final String? d5;
  // final String? d6;
  // final String? d7;
  // final String? d8;
  // final String? d9;
  // final String? d10;
  // final String? d11;
  // final String? d12;
  // final String? d13;
  // final String? d14;
  // final String? d15;
  // final String? d16;
  // final String? d17;
  // final String? d18;
  // final String? d19;
  // final String? d20;
  // final String? d21;
  // final String? d22;
  // final String? d23;
  // final String? d24;
  // final String? d25;
  // final String? d26;
  // final String? d27;
  // final String? d28;
  // final String? d29;
  // final String? d30;
  // final String? d31;
  // final int soNgayDiLam;
  // final int soNgayNghiPhep;
  // final int soNgayNghiKhongLuong;
  // final int soNgayDiLamNuaBuoi;

  ChiTietKyCong({
    this.id,
    required this.title,
    required this.kyCongId,
  required this.day,
    required this.date,
    required this.chamCongNgay,
    required this.thuNhapThucTe
    // this.wageOfMonth = 0,
    // this.d1,
    // this.d2,
    // this.d3,
    // this.d4,
    // this.d5,
    // this.d6,
    // this.d7,
    // this.d8,
    // this.d9,
    // this.d10,
    // this.d11,
    // this.d12,
    // this.d13,
    // this.d14,
    // this.d15,
    // this.d16,
    // this.d17,
    // this.d18,
    // this.d19,
    // this.d20,
    // this.d21,
    // this.d22,
    // this.d23,
    // this.d24,
    // this.d25,
    // this.d26,
    // this.d27,
    // this.d28,
    // this.d29,
    // this.d30,
    // this.d31,
    // this.soNgayDiLam = 0, this.soNgayNghiPhep = 0, this.soNgayNghiKhongLuong = 0, this.soNgayDiLamNuaBuoi = 0,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'kyCongId': kyCongId,
      'day': day,
      'date': date,
      'chamCongNgay': json.encode(chamCongNgay),
      'thuNhapThucTe': thuNhapThucTe
      // 'wageOfMonth': wageOfMonth,
      // 'd1': d1,
      // 'd2': d2,
      // 'd3': d3,
      // 'd4': d4,
      // 'd5': d5,
      // 'd6': d6,
      // 'd7': d7,
      // 'd8': d8,
      // 'd9': d9,
      // 'd10': d10,
      // 'd11': d11,
      // 'd12': d12,
      // 'd13': d13,
      // 'd14': d14,
      // 'd15': d15,
      // 'd16': d16,
      // 'd17': d17,
      // 'd18': d18,
      // 'd19': d19,
      // 'd20': d20,
      // 'd21': d21,
      // 'd22': d22,
      // 'd23': d23,
      // 'd24': d24,
      // 'd25': d25,
      // 'd26': d26,
      // 'd27': d27,
      // 'd28': d28,
      // 'd29': d29,
      // 'd30': d30,
      // 'd31': d31,
      // 'soNgayDiLam': soNgayDiLam,
      // 'soNgayNghiPhep': soNgayNghiPhep,
      // 'soNgayNghiKhongLuong': soNgayNghiKhongLuong,
      // 'soNgayDiLamNuaBuoi': soNgayDiLamNuaBuoi
    };
  }

  factory ChiTietKyCong.fromMap(Map<String, dynamic> map) {
    return ChiTietKyCong(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      day: map['day'],
      kyCongId: map['kyCongId'],
      chamCongNgay: json.decode(map['chamCongNgay']).cast<int>(),
        thuNhapThucTe: map['thuNhapThucTe']?.toInt() ?? 0,
      date: map['date'],
      //
      // wageOfMonth: map['wageOfMonth']?.toInt() ?? 0,
      // d1: map['d1'],
      // d2: map['d2'],
      // d3: map['d3'],
      // d4: map['d4'],
      // d5: map['d5'],
      // d6: map['d6'],
      // d7: map['d7'],
      // d8: map['d8'],
      // d9: map['d9'],
      // d10: map['d10'],
      // d11: map['d11'],
      // d12: map['d12'],
      // d13: map['d13'],
      // d14: map['d14'],
      // d15: map['d15'],
      // d16: map['d16'],
      // d17: map['d17'],
      // d18: map['d18'],
      // d19: map['d19'],
      // d20: map['d20'],
      // d21: map['d21'],
      // d22: map['d22'],
      // d23: map['d23'],
      // d24: map['d24'],
      // d25: map['d25'],
      // d26: map['d26'],
      // d27: map['d27'],
      // d28: map['d28'],
      // d29: map['d29'],
      // d30: map['d30'],
      // d31: map['d31'],
      //   soNgayDiLam: map['soNgayDiLam'],
      //   soNgayNghiPhep: map['soNgayNghiPhep'],
      //   soNgayNghiKhongLuong: map['soNgayNghiKhongLuong'],
      //   soNgayDiLamNuaBuoi: map['soNgayDiLamNuaBuoi']
    );
  }

  String toJson() => json.encode(toMap());

  factory ChiTietKyCong.fromJson(String source) =>
      ChiTietKyCong.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'ChiTietKyCong(id: $id, title: $title, day: $day, chamCongNgay: $chamCongNgay)';
}
