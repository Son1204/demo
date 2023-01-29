import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loadmore/loadmore.dart';
import 'package:test123/models/bonus.dart';
import 'package:test123/models/log.dart';
import '../models/employee.dart';
import '../services/database_service.dart';

class LogPageBonus extends StatefulWidget {
  const LogPageBonus({Key? key, this.employee, required this.selectedDate}) : super(key: key);
  final Employee? employee;
  final DateTime selectedDate;

  @override
  _LogPageBonus createState() => _LogPageBonus();
}

class _LogPageBonus extends State<LogPageBonus> {
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('vi').format(int.parse(s));

  int page = 0;
  bool maxNumber = false;
  int count = 0;
  List<Bonus> list = [];

  final DatabaseService _databaseService = DatabaseService();

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    page = page + 10;
    await load(page);
    return true;
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    list.clear();
    maxNumber = false;
    count = 0;
    load(0);
    page = 0;
  }

  Future<void> load(int page1) async {
    print("(load)page: "+page1.toString());
    await _databaseService
        .findBonusByEmployeeAndDateTimeAndPage(widget.employee!.id!, widget.selectedDate, page1)
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
        title: Text('Phụ cấp nhân viên: ' + widget.employee!.name),
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Container(
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
                                Text(
                                  "Thông báo",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: list[index].daTraTien==1?Colors.blue:Colors.deepOrangeAccent,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Ngày:' + DateFormat("dd/MM/yyyy").format(DateTime(list[index].year, list[index].month, list[index].day))),
                              ],
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  list[index].description == '' ? "Thưởng/Phụ cấp" : list[index].description,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: list[index].daTraTien==1?Colors.blue:Colors.deepOrangeAccent
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Ghi chú: " + list[index].description + '; '+ (list[index].daTraTien == 1 ? 'Đã thanh toán' : 'Chưa thanh toán'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  _formatNumber(list[index].soTien.toString()) +
                                      'đ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     bottom: 10,
                  //     top: 10,
                  //     left: 5,
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       const SizedBox(
                  //         height: 10,
                  //       ),
                  //       const Text('Chi tiết:'),
                  //       const SizedBox(
                  //         height: 10,
                  //       ),
                  //       JsonViewer(json.decode(list[index].dataJson)),
                  //     ],
                  //   ),
                  // ),
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
