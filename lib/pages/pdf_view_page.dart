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
  String path = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateInvoice(widget.employee).then((value) {
      print(value);
      path = value!;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(path == '') {
      return Text('Loading');
    }
    return Scaffold(
      body: Container(
        child: PDFView(
          filePath: path,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onRender: (_pages) {
            setState(() {
              pages = _pages;
              isReady = true;
            });
          },
          onError: (error) {
            print(error.toString());
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
        ),
      ),
    );
  }
}
