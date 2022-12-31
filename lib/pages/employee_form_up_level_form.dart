import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test123/models/log.dart';
import 'package:test123/models/up_level.dart';
import '../models/employee.dart';
import '../services/database_service.dart';

class EmployeeFormUpLevelPage extends StatefulWidget {
  const EmployeeFormUpLevelPage({Key? key, this.employee}) : super(key: key);
  final Employee? employee;

  @override
  _EmployeeFormUpLevelPage createState() => _EmployeeFormUpLevelPage();
}

class _EmployeeFormUpLevelPage extends State<EmployeeFormUpLevelPage> {
  final TextEditingController _descController = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  final TextEditingController _wageNewController = TextEditingController();

  bool tatToan = false;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('vi').format(int.parse(s));

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: 'vi').currencySymbol;

  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _descController.text = '';
      _wageNewController.text = _formatNumber('0');
      var date = DateTime.now();
      var formattedDate = "${date.day}-${date.month}-${date.year}";
      dateinput.text = formattedDate;
    }
  }

  Future<void> _onSave() async {
    final description = _descController.text;
    final wage = _wageNewController.text.replaceAll('.', '');

    var date = DateTime.now();
    var luongMoi = int.parse(wage);

    UpLevel upLevel = UpLevel(
      wageOld: widget.employee!.wage,
      wageNew: luongMoi,
      description: description,
      employeeId: widget.employee!.id!,
      day: date.day,
      month: date.month,
      year: date.year,
    );
    _databaseService.insertUpLevel(upLevel);
    widget.employee!.wageOld = widget.employee!.wage;
    widget.employee!.wage = luongMoi;
    widget.employee!.dateUpLevel =  DateFormat('yyyyMMdd').format(date);
    _databaseService.updateEmployee(widget.employee!);
    Log log = Log(
      day: date.day,
      month: date.month,
      year: date.year,
      description: description,
      date: date.toString(),
      dataJson: json.encode(upLevel),
      employeeId: widget.employee!.id!,
    );
    _databaseService.insertLog(log);
    // TODO: sonct cập nhật những ngày công từ ngày tăng lương
    _databaseService
        .findChiTietKyCongsByEmployeeIdAndDateTime(widget.employee!.id!, date)
        .then((chiTietKyCongs) {
      for (var chiTietKyCong in chiTietKyCongs) {
        print(chiTietKyCong);
        if (chiTietKyCong.chamCongNgay[0] == 1) {
          chiTietKyCong.thuNhapThucTe = luongMoi;
        } else if (chiTietKyCong.chamCongNgay[1] == 1 ||
            chiTietKyCong.chamCongNgay[2] == 1) {
          chiTietKyCong.thuNhapThucTe = (luongMoi / 2).round();
        }
        _databaseService.updateChiTietKyCong(chiTietKyCong);
      }
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Tăng lương: ' + widget.employee!.name),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text(
                        'Mức lương/ngày cũ: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatNumber(widget.employee!.wage.toString()) + ' đ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _wageNewController,
                    decoration: InputDecoration(
                      prefixText: _currency,
                      hintText: '0VNĐ',
                      label: const Text('Mức lương/ngày mới: '),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = _formatNumber(string.replaceAll('.', ''));
                      _wageNewController.value = TextEditingValue(
                        text: string,
                        selection:
                            TextSelection.collapsed(offset: string.length),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      hintText: 'Ghi chú',
                      label: Text('Ghi chú'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller:
                        dateinput, //editing controller of this TextField
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Ngày tăng lương", //label text of field
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101),
                        errorFormatText: 'Enter valid date',
                        errorInvalidText: 'Enter date in valid range',
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        setState(() {
                          dateinput.text = formattedDate;
                        });
                      } else {
                        var date = DateTime.now();
                        var formattedDate =
                            "${date.day}-${date.month}-${date.year}";
                        dateinput.text = formattedDate;
                        print("Date is not selected");
                      }
                    },
                  ),
                  SizedBox(
                    height: 45.0,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      child: const Text(
                        'Lưu lại',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
