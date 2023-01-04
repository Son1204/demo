import 'dart:io';
import 'package:excel/excel.dart';


List<String> rowdetail = [];

void importFromExcel() async {
  var bytes = File("storage/sdcard0/Download/example.xls").readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows) {
      rowdetail.add(row.toString());
    }
  }

  print(rowdetail);
}
