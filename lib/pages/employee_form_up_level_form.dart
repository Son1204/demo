import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test123/models/log.dart';
import 'package:test123/models/up_level.dart';
import '../common_widgets/confirm_builder.dart';
import '../models/employee.dart';
import '../services/database_service.dart';
import '../ultil/common.dart';

class EmployeeFormUpLevelPage extends StatefulWidget {
  const EmployeeFormUpLevelPage(
      {Key? key, this.employee, required this.onReload})
      : super(key: key);
  final Employee? employee;
  final Function onReload;

  @override
  _EmployeeFormUpLevelPage createState() => _EmployeeFormUpLevelPage();
}

class _EmployeeFormUpLevelPage extends State<EmployeeFormUpLevelPage> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
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
      _dateController.text = formattedDate;
    }
  }

  Future<void> _onSave() async {
    final description = _descController.text;
    final wage = _wageNewController.text.replaceAll('.', '');
    final dateChoose = _dateController.text.split('-');

    // DateTime(1998, 12, 04)
    // var day = dateChoose[0];
    print(dateChoose);
    var date = DateTime(int.parse(dateChoose[2]), int.parse(dateChoose[1]),
        int.parse(dateChoose[0]));
    var luongMoi = int.parse(wage);

    if (luongMoi == 0) {
      return;
    }

    if (await confirm(context,
        title: Text('X??c nh???n: thay ?????i l????ng/ng??y t??? ' +
            _formatNumber(widget.employee!.wage.toString()) +
            '?? th??nh ' +
            _formatNumber(luongMoi.toString()) +
            '?? cho nh??n vi??n: ' +
            widget.employee!.name))) {
      UpLevel upLevel = UpLevel(
        wageOld: widget.employee!.wage,
        wageNew: luongMoi,
        description: description,
        employeeId: widget.employee!.id!,
        day: date.day,
        month: date.month,
        year: date.year,
        date: DateFormat('yyyyMMdd').format(date),
      );
      _databaseService.insertUpLevel(upLevel);
      widget.employee!.wageOld = widget.employee!.wage;
      widget.employee!.wage = luongMoi;
      widget.employee!.dateUpLevel = DateFormat('yyyyMMdd').format(date);
      _databaseService.updateEmployee(widget.employee!);
      Log log = Log(
        day: date.day,
        month: date.month,
        year: date.year,
        description: '??i???u ch???nh l????ng',
        descriptionOfUser: description == ''
            ? 'L????ng/ng??y c??: ' +
                _formatNumber(widget.employee!.wageOld.toString()) +
                ', m???i: '
            : description +
                ', ' +
                'L????ng/ng??y c??: ' +
                _formatNumber(widget.employee!.wageOld.toString()) +
                ', m???i: ',
        soTien: luongMoi,
        date: DateFormat('yyyyMMdd').format(DateTime.now()),
        dataJson: json.encode(upLevel),
        employeeId: widget.employee!.id!,
        dateTime: DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now()),
      );
      _databaseService.insertLog(log);

      updateGoogleSheetAndLog(
          'L????ng/ng??y m???i:' +
              luongMoi.toString() +
              ",L????ng/ng??y c??:" +
              widget.employee!.wageOld.toString() +
              ",Ng??y ??p d???ng: " +
              DateFormat('yyyyMMdd').format(date) +
              "," +
              description,
          widget.employee!.id! + 2,
          date.day + 1,
          "DieuChinhLuong");

      // TODO: c???p nh???t nh???ng ng??y c??ng t??? ng??y t??ng l????ng
      _databaseService
          .findChiTietKyCongsByEmployeeIdAndDateTime(
              widget.employee!.id!, DateFormat('yyyyMMdd').format(date))
          .then((chiTietKyCongs) {
        for (var chiTietKyCong in chiTietKyCongs) {
          print(chiTietKyCong);
          if (chiTietKyCong.chamCongNgay[0] == 1) {
            chiTietKyCong.thuNhapThucTe = luongMoi;
            widget.employee!.chuaThanhToan = widget.employee!.chuaThanhToan +
                (luongMoi - widget.employee!.wageOld);
          } else if (chiTietKyCong.chamCongNgay[1] == 1 ||
              chiTietKyCong.chamCongNgay[2] == 1) {
            chiTietKyCong.thuNhapThucTe = (luongMoi / 2).round();
            widget.employee!.chuaThanhToan = widget.employee!.chuaThanhToan +
                ((luongMoi / 2).round() -
                    (widget.employee!.wageOld / 2).round());
          }

          updateGoogleSheet(chiTietKyCong.thuNhapThucTe,
              widget.employee!.id! + 2, chiTietKyCong.day + 1, "Luong");

          _databaseService.updateChiTietKyCong(chiTietKyCong);
        }
        _databaseService.updateEmployee(widget.employee!);
        widget.onReload();
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('??i???u ch???nh l????ng: ' + widget.employee!.name),
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
                    'M???c l????ng/ng??y hi???n t???i: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatNumber(widget.employee!.wage.toString()) + ' ??',
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
                  hintText: '0VN??',
                  label: const Text('M???c l????ng/ng??y m???i: '),
                ),
                keyboardType: TextInputType.number,
                onChanged: (string) {
                  string = _formatNumber(string.replaceAll('.', ''));
                  _wageNewController.value = TextEditingValue(
                    text: string,
                    selection: TextSelection.collapsed(offset: string.length),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  hintText: 'Ghi ch??',
                  label: Text('Ghi ch??'),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller:
                    _dateController, //editing controller of this TextField
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Ng??y ??p d???ng", //label text of field
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
                      _dateController.text = formattedDate;
                    });
                  } else {
                    var date = DateTime.now();
                    var formattedDate =
                        "${date.day}-${date.month}-${date.year}";
                    _dateController.text = formattedDate;
                    print("Date is not selected");
                  }
                },
              ),
              SizedBox(
                height: 45.0,
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: const Text(
                    'L??u l???i',
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
    );
  }
}
