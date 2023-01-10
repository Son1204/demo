import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:loadmore/loadmore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test123/models/log.dart';
import 'package:test123/models/up_level.dart';
import '../common_widgets/report_builder.dart';
import '../models/employee.dart';
import '../services/database_service.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_file_view/flutter_file_view.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({Key? key, required this.employee}) : super(key: key);
  final Employee employee;

  @override
  _PdfViewPage createState() => _PdfViewPage();
}


class _PdfViewPage extends State<PdfViewPage> {

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String localPath = '';
  final DatabaseService _databaseService = DatabaseService();
  var dateTime = DateTime.now();

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('vi').format(int.parse(s));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
      _databaseService
          .findKyCongIdByEmployeeAndDateTime(widget.employee.id!, dateTime)
          .then((kyCong) {
        _databaseService
            .findChiTietKyCongByKyCongId(kyCong.id!)
            .then((chiTietKyCongs) {
          _databaseService
              .findBillsByEmployeeAndDateTime(widget.employee.id!, dateTime)
              .then((bills) async {
            print("PDF");
            //Create a PDF document.
            final PdfDocument document = PdfDocument();
            //Add page to the PDF
            final PdfPage page = document.pages.add();

            //Get page client size
            final Size pageSize = page.getClientSize();

            //Generate PDF grid.
            chiTietKyCongs.sort((var a, var b) {
              if(int.parse(a.date) > int.parse(b.date)){
                return 1;
              } else if(int.parse(a.date) == int.parse(b.date)) {
                return 0;
              } else {
                return -1;
              }
            });
            final PdfGrid grid = getGrid(chiTietKyCongs);
            //Draw the header section by creating text element
            final PdfLayoutResult resultHeader =
            drawHeader(page, pageSize, grid, widget.employee);

            final Uint8List fontData =
            File('/storage/sdcard0/Download/Roboto/Roboto-Bold.ttf')
                .readAsBytesSync();
            final PdfFont font =
            PdfTrueTypeFont(fontData, 18, style: PdfFontStyle.bold);
            final Uint8List fontDataRe =
            File('/storage/sdcard0/Download/Roboto/Roboto-Regular.ttf')
                .readAsBytesSync();
            final PdfFont fontRe =
            PdfTrueTypeFont(fontDataRe, 18, style: PdfFontStyle.regular);

            PdfLayoutResult resultTitleWage = PdfTextElement(
                text:
                "Ngày công trong tháng " + DateFormat("MM/yyyy").format(DateTime.now())+ ': ',
                font: font)
                .draw(
                page: resultHeader.page,
                bounds:
                Rect.fromLTWH(10, resultHeader.bounds.bottom + 20, 0, 0))!;

            //Draw grid
            PdfLayoutResult result1 = grid.draw(
                page: resultTitleWage.page,
                bounds:
                Rect.fromLTWH(0, resultTitleWage.bounds.bottom + 10, 0, 0))!;

            var soCongTrongThang = 0;
            var luongThang = 0;

            for (var element in chiTietKyCongs) {
              print('Load summary day:' + element.chamCongNgay.toString());
              if (element.chamCongNgay[0] == 1) {
                soCongTrongThang += 1;
              } else if (element.chamCongNgay[1] == 1 ||
                  element.chamCongNgay[2] == 1) {
                soCongTrongThang = soCongTrongThang + 0.5.round();
              }
              luongThang += element.thuNhapThucTe;
            }

            PdfLayoutResult resultTitleTotalWage = PdfTextElement(
                text: 'Tổng hợp ngày công tháng ' +
                    DateFormat("MM/yyyy").format(DateTime.now())+': ' +
                    soCongTrongThang.toString() +
                    ' công',
                font: font)
                .draw(
                page: result1.page,
                bounds: Rect.fromLTWH(10, result1.bounds.bottom + 40, 0, 0))!;

            PdfLayoutResult resultGetTotalWage = getTotalWage(chiTietKyCongs).draw(
              page: resultTitleTotalWage.page,
              bounds:
              Rect.fromLTWH(0, resultTitleTotalWage.bounds.bottom + 10, 0, 0),
            )!;

            PdfLayoutResult resultTitleTotal = PdfTextElement(
                text: 'Lương và các khoản thanh toán tháng ' +
                    DateFormat("MM/yyyy").format(DateTime.now())+': ',
                font: font)
                .draw(
                page: resultGetTotalWage.page,
                bounds: Rect.fromLTWH(
                    10, resultGetTotalWage.bounds.bottom + 40, 0, 0))!;

            PdfLayoutResult resultTitleTotalMonth = PdfTextElement(
                text: 'Lương tháng ' +
                    DateFormat("MM/yyyy").format(DateTime.now())+': ' +
                    _formatNumber(luongThang.toString()) +
                    ' vnđ',
                font: font)
                .draw(
                page: resultTitleTotal.page,
                bounds: Rect.fromLTWH(
                    10, resultTitleTotal.bounds.bottom + 5, 0, 0))!;

            PdfLayoutResult totalNeedPay = PdfTextElement(
                text: 'Số tiền cần phải trả: todo' +
                    DateFormat("MM/yyyy").format(DateTime.now())+': ' +
                    _formatNumber(luongThang.toString()) +
                    'vnđ',
                font: font)
                .draw(
                page: resultTitleTotal.page,
                bounds: Rect.fromLTWH(
                    10, resultTitleTotal.bounds.bottom + 5, 0, 0))!;

            if(bills.isEmpty) {
              PdfTextElement(text: 'Chưa thanh toán', font: fontRe).draw(
                page: totalNeedPay.page,
                bounds:
                Rect.fromLTWH(15, totalNeedPay.bounds.bottom + 10, 0, 0),
              );
            } else {
              getTotal(bills).draw(
                page: totalNeedPay.page,
                bounds:
                Rect.fromLTWH(0, totalNeedPay.bounds.bottom + 10, 0, 0),
              );
            }


            //Save the PDF document
            List<int> bytes = document.saveSync();
            //Dispose the document.
            document.dispose();
            //Save and launch the file.
            final path = (await getExternalStorageDirectory())?.path;
            final file = File('$path/Report.pdf');
            await file.writeAsBytes(bytes, flush: true);

            // TODO: SONCT
            localPath = path!+'/Report.pdf';
            setState(() {

            });
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: localPath != ''
          ? PDFView(
        filePath: localPath,
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
