import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:intl/intl.dart';
import 'package:loadmore/loadmore.dart';
import 'package:test123/models/log.dart';
import 'package:test123/models/up_level.dart';
import '../models/employee.dart';
import '../services/database_service.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key, this.employee}) : super(key: key);
  final Employee? employee;

  @override
  _LogPage createState() => _LogPage();
}

class _LogPage extends State<LogPage> {
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('vi').format(int.parse(s));

  int page = 0;
  bool maxNumber = false;
  int count = 0;
  List<Log> list = [];

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: 'vi').currencySymbol;

  final DatabaseService _databaseService = DatabaseService();

  Future<List<Log>> _getLogEmployee(int employeeId) async {
    return await _databaseService.findLogsByEmployee(employeeId, page);
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    load(page + 1);
    return true;
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    list.clear();
    count = 0;
    load(0);
  }

  void load(int page1) {
    print("load");
    _databaseService
        .findLogsByEmployee(widget.employee!.id!, page1)
        .then((values) {
      // print(values)
      if (values.length < 10) {
        maxNumber = true;
      }
      print('VALUES LENGTH: ' + values.length.toString());
      list.addAll(values);
      count = list.length;
      print("data count = ${list.length}");
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list.clear();
    count = 0;
    load(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử nhân viên: ' + widget.employee!.name),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        child: LoadMore(
          isFinish: maxNumber,
          onLoadMore: _loadMore,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        top: 10,
                        left: 5,
                      ),
                      child: Row(
                        children: [
                          Text(index.toString()),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Thông báo",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Ngày:' + list[index].dateTime.toString()),
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(list[index].description +
                              ', nhân viên: ' +
                              list[index].employeeName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      top: 10,
                      left: 5,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Chi tiết:'),
                        const SizedBox(
                          height: 10,
                        ),
                        JsonViewer(json.decode(list[index].dataJson)),
                      ],
                    ),
                  ),
                ],
              );
            },
            itemCount: count,
          ),
          whenEmptyLoad: false,
          delegate: const DefaultLoadMoreDelegate(),
          textBuilder: DefaultLoadMoreTextBuilder.english,
        ),
        onRefresh: _refresh,
      ),
    );
  }
}
