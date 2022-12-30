import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_file_view/flutter_file_view.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  print("OPEN PDF");
  final path = (await getExternalStorageDirectory())?.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open('$path/$fileName');
  print('$path/$fileName');
  print("OPENED PDF");
}

/// Represents the PDF stateful widget class.
class CreatePdfStatefulWidget extends StatefulWidget {
  /// Initalize the instance of the [CreatePdfStatefulWidget] class.
  const CreatePdfStatefulWidget({Key? key}) : super(key: key);

  @override
  _CreatePdfState createState() => _CreatePdfState();
}

class _CreatePdfState extends State<CreatePdfStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create PDF document'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlue,
              ),
              onPressed: generateInvoice,
              child: const Text('Generate PDF'),
            ),
            // Expanded(child: FileView(
            //   controller: FileViewController.asset('/storage/sdcard0/Android/data/com.example.test123/files/Invoice.pdf'),
            // ),
            // ),
          ],
        ),
      ),
    );
  }

}

Future<void> generateInvoice() async {
  print("PDF");
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add page to the PDF
  final PdfPage page = document.pages.add();

  //Get page client size
  final Size pageSize = page.getClientSize();

  //Generate PDF grid.
  final PdfGrid grid = getGrid();
  //Draw the header section by creating text element
  final PdfLayoutResult resultHeader = drawHeader(page, pageSize, grid);

  final Uint8List fontData =
  File('/storage/sdcard0/Download/Roboto/Roboto-Bold.ttf')
      .readAsBytesSync();
  final PdfFont font =
  PdfTrueTypeFont(fontData, 18, style: PdfFontStyle.bold);

  DateTime current = DateTime.now();

  PdfLayoutResult resultTitleWage = PdfTextElement(
      text: "Ngày công trong tháng "+current.month.toString()+': ', font: font)
      .draw(
      page: resultHeader.page,
      bounds: Rect.fromLTWH(10, resultHeader.bounds.bottom + 20, 0, 0))!;

  //Draw grid
  PdfLayoutResult result1 = grid.draw(
      page: resultTitleWage.page,
      bounds: Rect.fromLTWH(0, resultTitleWage.bounds.bottom + 10, 0, 0))!;

  PdfLayoutResult resultTitleTotalWage =
  PdfTextElement(text: 'Tổng hợp ngày công tháng '+current.month.toString()+': 5 công', font: font)
      .draw(
      page: result1.page,
      bounds: Rect.fromLTWH(10, result1.bounds.bottom + 40, 0, 0))!;

  PdfLayoutResult resultGetTotalWage = getTotalWage().draw(
    page: resultTitleTotalWage.page,
    bounds: Rect.fromLTWH(0, resultTitleTotalWage.bounds.bottom + 10, 0, 0),
  )!;

  PdfLayoutResult resultTitleTotal =
  PdfTextElement(text: 'Lương và các khoản thanh toán tháng '+current.month.toString()+': ', font: font).draw(
      page: resultGetTotalWage.page,
      bounds: Rect.fromLTWH(
          10, resultGetTotalWage.bounds.bottom + 40, 0, 0))!;

  PdfLayoutResult resultTitleTotalMonth =
  PdfTextElement(text: 'Lương tháng '+current.month.toString()+': 0đ', font: font).draw(
      page: resultTitleTotal.page,
      bounds:
      Rect.fromLTWH(10, resultTitleTotal.bounds.bottom + 5, 0, 0))!;

  getTotal().draw(
    page: resultTitleTotalMonth.page,
    bounds: Rect.fromLTWH(0, resultTitleTotalMonth.bounds.bottom + 10, 0, 0),
  );

  //Save the PDF document
  List<int> bytes = document.saveSync();
  //Dispose the document.
  document.dispose();
  //Save and launch the file.
  await saveAndLaunchFile(bytes, 'Report.pdf');
}


//Draws the invoice header
PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
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

  DateTime current = DateTime.now();
  DateTime lastDayCurrentMonth = DateTime.utc(current.year,current.month+1,).subtract(const Duration(days: 1));

  String title = 'Bảng lương(1/'+current.month.toString()+'/'+current.year.toString()+' - '+lastDayCurrentMonth.day.toString()+'/'+current.month.toString()+'/'+current.year.toString()+')';

  //Draw string
  PdfTextElement(text: title, font: fontHeader).draw(
      page: page,
      bounds: Rect.fromLTWH(50, 20, pageSize.width, pageSize.height - 50));

  PdfTextElement(
          text: 'Báo cáo được tạo ngày: ' + DateFormat('dd/MM/yyyy hh:mm').format(current).toString(),
          font: font)
      .draw(
          page: page,
          bounds: Rect.fromLTWH(60, 70, pageSize.width, pageSize.height - 50));

  //Draw string
  const String address = '''Tên nhân viên: Chu Trọng Sơn 
        \r\nGhi chú: 
        \r\nLương/Ngày: 300.000 vnđ''';

  return PdfTextElement(text: address, font: font)
      .draw(page: page, bounds: Rect.fromLTWH(10, 120, pageSize.width, 0))!;
}

PdfGrid getGrid() {
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

  //Add rows
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);
  addDayWage('son', 'ca ngay', 1200, grid);

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

PdfGrid getTotal() {
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
  headerRow.cells[1].value = 'Nội dung';
  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[2].value = 'Số tiền';
  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;

  //Add rows
  addDayWage('son', 'ca ngay', 1200, grid);

  //Apply the table built-in style
  //Set gird columns width
  grid.columns[1].width = 300;
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

PdfGrid getTotalWage() {
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
  addTotalWage(5, 4, 1, 0, grid);

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

void addDayWage(String workDay, String wage, int soTienThucTe, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  //Create a PDF grid
  final Uint8List fontData =
      File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
          .readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 18);
  row.style.font = font;
  row.cells[0].value = workDay;
  row.cells[1].value = wage;
  row.cells[2].value = soTienThucTe.toString();
}
