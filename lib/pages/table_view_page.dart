import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'package:quiver/time.dart';

class SimpleTablePage extends StatefulWidget {
  const SimpleTablePage({
    Key? key,
  }) : super(key: key);


  @override
  _SimpleTablePageState createState() => _SimpleTablePageState();
}

class _SimpleTablePageState extends State<SimpleTablePage> {

  var user = [];
  final DatabaseService _databaseService = DatabaseService();
  var details = [];


  @override
  void initState() {

    _databaseService.findAllEmployees().then((value) {
      user = value;
      setState(() {

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Table')),
      // body: HorizontalDataTable(
      //   leftHandSideColumnWidth: 100,
      //   rightHandSideColumnWidth: 600,
      //   isFixedHeader: true,
      //   headerWidgets: _getTitleWidget(),
      //   leftSideItemBuilder: _generateFirstColumnRow,
      //   rightSideItemBuilder: _generateRightHandSideColumnRow,
      //   itemCount: user.length,
      //   rowSeparatorWidget: const Divider(
      //     color: Colors.black54,
      //     height: 1.0,
      //     thickness: 0.0,
      //   ),
      //   leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
      //   rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
      // ),
    );
  }

  List<Widget> _getTitleWidget() {
    var date = DateTime.now();
    var days = daysInMonth(date.year, date.month);
    List<Widget> widgets = [];

    for (int i = 0; i < days; i++) {
      widgets.add(_getTitleItemWidget(formatDayAndMonth(i+1, date.month), 100));
    }

    return widgets;
    //
    // return [
    //
    //   _getTitleItemWidget('Status', 100),
    //   _getTitleItemWidget('Phone', 200),
    //   _getTitleItemWidget('Register', 100),
    //   _getTitleItemWidget('Termination', 200),
    // ];
  }

  String formatDayAndMonth(int day, int month){
    var result = '';
    if(day < 10) {
      result += '0' + day.toString();
    }else {
      result += day.toString();
    }

    result += '/';

    if(month < 10) {
      result += '0' + month.toString();
    }else {
      result += month.toString();
    }

    return result;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(user[index].name),
      width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {

  _databaseService.findChiTietKyCongByEmployeeAndDate(user[index].id!, DateTime.now()).then((values) {



    setState(() {

    });
  });

  if(details.isEmpty) {
    return const Text("");
  }

    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Active')
            ],
          ),
          width: 100,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user[index].wageOld.toString()),
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user[index].wageOld.toString()),
          width: 100,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user[index].wageOld.toString()),
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}