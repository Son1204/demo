import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test123/models/bill.dart';
import '../common_widgets/confirm_builder.dart';
import '../models/bonus.dart';
import '../models/employee.dart';
import '../models/log.dart';
import '../services/database_service.dart';
import '../ultil/common.dart';

class EmployeeFormBonusPage extends StatefulWidget {
  const EmployeeFormBonusPage({Key? key, this.employee, required this.onReload}) : super(key: key);
  final Employee? employee;
  final Function onReload;

  @override
  _EmployeeFormBonusPage createState() => _EmployeeFormBonusPage();
}

class _EmployeeFormBonusPage extends State<EmployeeFormBonusPage> {
  final TextEditingController _descController = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  final TextEditingController _wageController = TextEditingController();

  bool daThanhToan = false;

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
      _wageController.text = _formatNumber('0');
      var date = DateTime.now();
      var formattedDate = "${date.day}-${date.month}-${date.year}";
      dateinput.text = formattedDate;
    }
  }

  Future<void> _onSave() async {
    final description = _descController.text;
    final wage = _wageController.text.replaceAll('.', '');

    var date = DateTime.now();
    var soTien = int.parse(wage);


    if(soTien == 0) {
      return;
    }

    if (await confirm(context,
        title: Text('Xác nhận: phụ cấp/thưởng ' +
            _formatNumber(widget.employee!.wage.toString()) +
            'đ cho nhân viên: ' +
            widget.employee!.name))) {
      if (daThanhToan) {
        // lưu thanh toán
        Bill bill = Bill(
          soTien: soTien,
          description: description == '' ? "Thưởng/Phụ cấp" : description,
          employeeId: widget.employee!.id!,
          day: date.day,
          month: date.month,
          year: date.year,
          date: DateFormat('yyyyMMdd').format(date),
        );
        _databaseService.insertBill(bill);

        updateGoogleSheetAndLog(soTien.toString() + "," +
            (description == '' ? 'Thưởng/Phụ cấp' : description),
            widget.employee!.id! + 2, date.day + 1, "Thuong/PhuCap");

        Log log = Log(
          day: date.day,
          month: date.month,
          year: date.year,
          descriptionOfUser: description,
          soTien: soTien,
          description: 'Thanh toán phụ cấp/thưởng',
          date: DateFormat('yyyyMMdd').format(date),
          dataJson: json.encode(bill),
          employeeId: widget.employee!.id!,
          dateTime: DateFormat('dd/MM/yyyy hh:mm').format(date),
        );
        _databaseService.insertLog(log);

        Bonus bonus = Bonus(
          soTien: soTien,
          description: description,
          employeeId: widget.employee!.id!,
          day: date.day,
          month: date.month,
          year: date.year,
            daTraTien: 1,
          date: DateFormat('yyyyMMdd').format(date),
        );
        _databaseService.insertBonus(bonus);

        // cập nhật tổng đã thanh toán
        widget.employee!.daThanhToan = widget.employee!.daThanhToan + soTien;

        _databaseService.updateEmployee(widget.employee!);
      } else {
        updateGoogleSheetAndLog(soTien.toString() + "," +
            (description == '' ? 'Thưởng/Phụ cấp' : description),
            widget.employee!.id! + 2, date.day + 1, "Thuong/PhuCap");

        Bonus bonus = Bonus(
          soTien: soTien,
          description: description,
          employeeId: widget.employee!.id!,
          day: date.day,
          month: date.month,
          year: date.year,
          daTraTien: 1,
          date: DateFormat('yyyyMMdd').format(date),
        );

        _databaseService.insertBonus(bonus);

        Log log1 = Log(
          day: date.day,
          month: date.month,
          year: date.year,
          description: 'Phụ cấp/Thưởng',
          descriptionOfUser: description,
          soTien: soTien,
          date: DateFormat('yyyyMMdd').format(date),
          dataJson: json.encode(bonus),
          employeeId: widget.employee!.id!,
          dateTime: DateFormat('dd/MM/yyyy hh:mm').format(date),
        );
        _databaseService.insertLog(log1);

        widget.employee!.chuaThanhToan =
            widget.employee!.chuaThanhToan + soTien;
        _databaseService.updateEmployee(widget.employee!);
      }

      widget.onReload();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('Thưởng/Phụ cấp: ' + widget.employee!.name),
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
                  TextField(
                    controller: _wageController,
                    decoration: InputDecoration(
                      prefixText: _currency,
                      hintText: '0VNĐ',
                      label: const Text('Số tiền thưởng/phụ cấp: '),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = _formatNumber(string.replaceAll('.', ''));
                      _wageController.value = TextEditingValue(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: daThanhToan,
                        onChanged: (value) {
                          setState(() {
                            daThanhToan = value!;
                          });
                        },
                      ),
                      const Text('Đã đưa tiền'),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
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
        );
  }
}
