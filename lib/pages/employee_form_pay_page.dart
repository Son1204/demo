import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test123/models/bill.dart';
import '../common_widgets/confirm_builder.dart';
import '../models/employee.dart';
import '../models/log.dart';
import '../services/database_service.dart';
import '../ultil/common.dart';

class EmployeeFormPayPage extends StatefulWidget {
  const EmployeeFormPayPage({Key? key, this.employee, required this.onReload}) : super(key: key);
  final Employee? employee;
  final Function onReload;

  @override
  _EmployeeFormPayPage createState() => _EmployeeFormPayPage();
}

class _EmployeeFormPayPage extends State<EmployeeFormPayPage> {
  final TextEditingController _descController = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  final TextEditingController _wageController = TextEditingController();

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
    
    if (await confirm(context, title: Text('Đồng ý thanh toán: '+_formatNumber(soTien.toString())+'đ cho nhân viên: '+widget.employee!.name))) {


      var buildMessage = soTien.toString();

      if(description == ''){
        buildMessage = buildMessage + ","+"Trả lương";
      }else {
        buildMessage = buildMessage + ","+description;
      }

      print(buildMessage);

      updateGoogleSheetAndLog(buildMessage, widget.employee!.id! + 2, date.day + 1, "ThanhToan");

      // lưu thanh toán
      Bill bill = Bill(
        soTien: soTien,
        description: description == ''?"Thanh toán lương":description,
        employeeId: widget.employee!.id!,
        day: date.day,
        month: date.month,
        year: date.year,
        date: DateFormat('yyyyMMdd').format(date),
      );
      _databaseService.insertBill(bill);

      Log log = Log(
        day: date.day,
        month: date.month,
        descriptionOfUser: description,
        soTien: soTien,
        year: date.year,
        description: 'Thanh toán lương',
        date: DateFormat('yyyyMMdd').format(date),
        dataJson: json.encode(bill),
        employeeId: widget.employee!.id!,
        dateTime: DateFormat('dd/MM/yyyy hh:mm').format(date),
      );
      _databaseService.insertLog(log);

      // trừ thông tin chưa thanh toán, thứ tự trừ tháng trước sau đó đến tổng
      widget.employee!.chuaThanhToan = widget.employee!.chuaThanhToan - soTien;

      // cập nhật đã thanh toán
      if(tatToan) {
        widget.employee!.daThanhToan = 0;
      }else {
        widget.employee!.daThanhToan = widget.employee!.daThanhToan + soTien;
      }

      _databaseService.updateEmployee(widget.employee!);
      Navigator.pop(context);
      widget.onReload();
      return print('pressedOK');
    }
    return print('pressedCancel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('Thanh toán lương: ' + widget.employee!.name),
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
                        'Số tiền chưa thanh toán: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatNumber(
                            widget.employee!.chuaThanhToan >= 0 ? widget.employee!.chuaThanhToan.toString() : "0") +
                            ' đ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text(
                        'Ứng trước: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatNumber(
                            widget.employee!.chuaThanhToan < 0 ? (widget.employee!.chuaThanhToan * -1).toString() : "0") +
                            ' đ',
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
                    controller: _wageController,
                    decoration: InputDecoration(
                      prefixText: _currency,
                      hintText: '0VNĐ',
                      label: const Text('Số tiền: '),
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
                  widget.employee!.chuaThanhToan > 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: tatToan,
                        onChanged: (value) {
                          setState(() {
                            if (!tatToan) {
                              _wageController.text = _formatNumber(
                                  widget.employee!.chuaThanhToan.toString());
                            } else {
                              _wageController.text = _formatNumber('0');
                            }
                            tatToan = value!;
                          });
                        },
                      ),
                      const Text('Tất toán'),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ) : Container(),
                  SizedBox(
                    height: 45.0,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      child: const Text(
                        'Lưu thành toán',
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
