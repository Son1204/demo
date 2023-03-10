import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_file_view/flutter_file_view.dart';
import 'package:test123/models/bill.dart';
import 'package:test123/models/bonus.dart';
import 'package:test123/models/employee.dart';
import 'package:test123/models/up_level.dart';

import '../models/chi_tiet_ky_cong.dart';
import '../services/database_service.dart';

Future<String> saveAndLaunchFile(List<int> bytes, String fileName) async {
  print("OPEN PDF");
  final path = (await getExternalStorageDirectory())?.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);

  // OpenFile.open('$path/$fileName');
  print('$path/$fileName');

  return path!+'/'+fileName;
  // print("OPENED PDF");
}

String _formatNumber(String s) =>
    NumberFormat.decimalPattern('vi').format(int.parse(s));

//Draws the invoice header
PdfLayoutResult drawHeader(
    PdfPage page, Size pageSize, PdfGrid grid, Employee employee, DateTime dateTime) {
  final Uint8List fontData =
      File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
          .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);
  final PdfFont fontBold =
      PdfTrueTypeFont(fontData, 18, style: PdfFontStyle.bold);

  final Uint8List fontDataBold =
      File('/storage/sdcard0/Download/Roboto/Roboto-Bold.ttf')
          .readAsBytesSync();

  final PdfFont fontHeader =
      PdfTrueTypeFont(fontDataBold, 26, style: PdfFontStyle.bold);

  DateTime current = dateTime;
  DateTime lastDayCurrentMonth = DateTime.utc(
    current.year,
    current.month + 1,
  ).subtract(const Duration(days: 1));

  String title = 'Bảng lương(1/' +
      current.month.toString() +
      '/' +
      current.year.toString() +
      ' - ' +
      lastDayCurrentMonth.day.toString() +
      '/' +
      current.month.toString() +
      '/' +
      current.year.toString() +
      ')';

  //Draw string
  PdfTextElement(text: title, font: fontHeader).draw(
      page: page,
      bounds: Rect.fromLTWH(50, 20, pageSize.width, pageSize.height - 50));

  PdfTextElement(
          text: 'Báo cáo được tạo ngày: ' +
              DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now()).toString(),
          font: font)
      .draw(
          page: page,
          bounds: Rect.fromLTWH(60, 70, pageSize.width, pageSize.height - 50));

  //Draw string
  String address = 'Tên nhân viên: ' +
      employee.name +
      '\r\nGhi chú: ' +
      employee.description +
      '\r\nLương/Ngày: ' +
      _formatNumber(employee.wage.toString()) +
      ' vnđ';

  return PdfTextElement(text: address, font: font)
      .draw(page: page, bounds: Rect.fromLTWH(10, 120, pageSize.width, 0))!;
}

PdfGrid getGrid(List<ChiTietKyCong> chiTietKyCongs) {
  //Create a PDF grid
  final Uint8List fontData =
      File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
          .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);

  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 3);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.style.font = font;

  //Set style
  headerRow.cells[0].value = 'Ngày đi làm';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Chấm công';
  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[2].value = 'Số tiền';
  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;

  var dateTime = DateTime.now();

  //Add rows
  for (var element in chiTietKyCongs) {
    var chamCong = '';

    if (element.chamCongNgay[0] == 1) {
      chamCong = 'Cả ngày';
    } else if (element.chamCongNgay[1] == 1) {
      chamCong = 'Buổi sáng';
    } else if (element.chamCongNgay[2] == 1) {
      chamCong = 'Buổi chiều';
    } else if (element.chamCongNgay[3] == 1) {
      chamCong = 'Nghỉ';
    }

    addDayWage(
      DateFormat("dd/MM/yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, element.day)),
        chamCong,
        _formatNumber(element.thuNhapThucTe.toString()),
        grid,
    );
  }

  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding = PdfPaddings(
      bottom: 5,
      left: 5,
      right: 5,
      top: 5,
    );
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      cell.style.cellPadding = PdfPaddings(
        bottom: 5,
        left: 5,
        right: 5,
        top: 5,
      );
    }
  }
  return grid;
}

PdfGrid getTotal(List<Bill> bills) {
  //Create a PDF grid
  final Uint8List fontData =
  File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
      .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);

  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 3);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];

  headerRow.style.font = font;

  //Set style
  headerRow.cells[0].value = 'Ngày thanh toán';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Số tiền';
  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[2].value = 'Nội dung';
  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;

  //Add rows
  for (var element in bills) {
    addDayWage(
      DateFormat("dd/MM/yyyy").format(DateTime(element.year, element.month, element.day)),
      _formatNumber(element.soTien.toString()),
      element.description,
      grid,
    );
  }

  //Apply the table built-in style
  //Set gird columns width
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding = PdfPaddings(
      bottom: 5,
      left: 5,
      right: 5,
      top: 5,
    );
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      cell.style.cellPadding = PdfPaddings(
        bottom: 5,
        left: 5,
        right: 5,
        top: 5,
      );
    }
  }
  return grid;
}


PdfGrid getBonus(List<Bonus> bonuses) {
  //Create a PDF grid
  final Uint8List fontData =
      File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
          .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);

  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 3);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];

  headerRow.style.font = font;

  //Set style
  headerRow.cells[0].value = 'Ngày';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Số tiền';
  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[2].value = 'Nội dung';
  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;

  //Add rows
  for (var element in bonuses) {
    drawRow(
        DateFormat("dd/MM/yyyy").format(DateTime(element.year, element.month, element.day)),
        _formatNumber(element.soTien.toString()),
        element.description==''?"Thưởng/Phụ cấp":element.description,
        grid,
    );
  }

  //Apply the table built-in style
  //Set gird columns width
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding = PdfPaddings(
      bottom: 5,
      left: 5,
      right: 5,
      top: 5,
    );
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      cell.style.cellPadding = PdfPaddings(
        bottom: 5,
        left: 5,
        right: 5,
        top: 5,
      );
    }
  }
  return grid;
}

PdfGrid getUpLevel(List<UpLevel> upLevels) {
  //Create a PDF grid
  final Uint8List fontData =
  File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
      .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);

  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 3);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];

  headerRow.style.font = font;

  //Set style
  headerRow.cells[0].value = 'Lương/Ngày cũ';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Lương/Ngày mới';
  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[2].value = 'Ngày áp dụng';
  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;

  //Add rows
  for (var element in upLevels) {
    addDayWage(
      _formatNumber(element.wageOld.toString()),
      _formatNumber(element.wageNew.toString()),
      DateFormat("dd/MM/yyyy").format(DateTime(element.year, element.month, element.day)),
      grid,
    );
  }

  //Apply the table built-in style
  //Set gird columns width
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding = PdfPaddings(
      bottom: 5,
      left: 5,
      right: 5,
      top: 5,
    );
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      cell.style.cellPadding = PdfPaddings(
        bottom: 5,
        left: 5,
        right: 5,
        top: 5,
      );
    }
  }
  return grid;
}


PdfGrid getTotalWage(List<ChiTietKyCong> chiTietKyCongs) {
  //Create a PDF grid
  final Uint8List fontData =
      File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
          .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);

  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 4);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];

  headerRow.style.font = font;

  //Set style
  headerRow.cells[0].value = 'Cả ngày';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Buổi sáng';
  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[2].value = 'Buổi chiều';
  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[3].value = 'Nghỉ';
  headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;

  //Add rows
  var soNVLamCaNgay = 0;
  var soNVLamBuoiSang = 0;
  var soNVLamBuoiChieu = 0;
  var soNVNghi = 0;

  for (var element in chiTietKyCongs) {
    print('Load summary day:' + element.chamCongNgay.toString());
    soNVLamCaNgay += element.chamCongNgay[0];
    soNVLamBuoiSang += element.chamCongNgay[1];
    soNVLamBuoiChieu += element.chamCongNgay[2];

    if(element.chamCongNgay[3] == 1) {
      soNVNghi += element.chamCongNgay[3];
    } else if(element.chamCongNgay[0] == 0 && element.chamCongNgay[1] == 0 && element.chamCongNgay[2] == 0) {
      soNVNghi += 1;
    }

  }
  addTotalWage(
      soNVLamCaNgay, soNVLamBuoiSang, soNVLamBuoiChieu, soNVNghi, grid);

  //Apply the table built-in style
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      cell.style.cellPadding = PdfPaddings(
        bottom: 5,
        left: 5,
        right: 5,
        top: 5,
      );
    }
  }
  return grid;
}

void addTotalWage(int i, int j, int k, int l, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  //Create a PDF grid
  final Uint8List fontData =
      File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
          .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);
  row.style.font = font;
  row.cells[0].value = i.toString();
  row.cells[1].value = j.toString();
  row.cells[2].value = k.toString();
  row.cells[3].value = l.toString();
}

void addDayWage(String i, String j, String k, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  //Create a PDF grid
  final Uint8List fontData =
      File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
          .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);
  row.style.font = font;
  row.cells[0].value = i;
  row.cells[1].value = j;
  row.cells[2].value = k;
}

void drawRow(String i, String j, String k, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  //Create a PDF grid
  final Uint8List fontData =
  File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
      .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);
  row.style.font = font;
  row.cells[0].value = i;
  row.cells[1].value = j;
  row.cells[2].value = k;
}
