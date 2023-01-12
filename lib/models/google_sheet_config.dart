import 'dart:convert';

class GoogleSheetConfig {
  final int? id;
  final int month;
  final int year;
  // List<int> chamCongNgay;

// Creating the setter method
  // to set the input in Field/Property
  // set setChamCongNgay(var ngayCong) {
  //   chamCongNgay = ngayCong;
  // }

  GoogleSheetConfig( {
    this.id,
    required this.month,
    required this.year
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'year': year,
      // 'chamCongNgay': json.encode(chamCongNgay)
    };
  }

  factory GoogleSheetConfig.fromMap(Map<String, dynamic> map) {
    print("(formMap)"+map.toString());
    return GoogleSheetConfig(
      id: map['id']?.toInt() ?? 0,
      month: map['month']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
      // chamCongNgay: json.decode(map['chamCongNgay']).cast<int>()
    );
  }

  String toJson() => json.encode(toMap());

  factory GoogleSheetConfig.fromJson(String source) => GoogleSheetConfig.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'GoogleSheetConfig(id: $id, month: $month, year: $year)';
}
