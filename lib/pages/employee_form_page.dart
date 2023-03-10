import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';
import '../models/log.dart';
import '../services/database_service.dart';
import '../ultil/common.dart';

class EmployeeFormPage extends StatefulWidget {
  const EmployeeFormPage({Key? key, this.employee}) : super(key: key);
  final Employee? employee;

  @override
  _EmployeeFormPage createState() => _EmployeeFormPage();
}

class _EmployeeFormPage extends State<EmployeeFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  static const _locale = 'vi';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  final TextEditingController _wageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _descController.text = widget.employee!.description;
      _wageController.text = _formatNumber(widget.employee!.wage.toString());
    }
  }

  final DatabaseService _databaseService = DatabaseService();

  Future<void> _onSave() async {
    final name = _nameController.text;
    final description = _descController.text;
    final wage = _wageController.text.replaceAll('.', '');
    // Add save code here
    widget.employee == null
        ? await _databaseService.insertEmployee(Employee(
            name: name,
            description: description,
            wage: int.parse(wage),
            wageOld: int.parse(wage),
            dateUpLevel: DateFormat('yyyyMMdd').format(DateTime.now()),
          )).then((employeeId) {
      var date = DateTime.now();

      updateGoogleSheet(name, employeeId + 2, 1, "NgayCong");
      updateGoogleSheet(name, employeeId + 2, 1, "Luong");
      updateGoogleSheet(name, employeeId + 2, 1, "Thuong/PhuCap");
      updateGoogleSheet(name, employeeId + 2, 1, "ThanhToan");
      updateGoogleSheet(name, employeeId + 2, 1, "DieuChinhLuong");

      Log log = Log(
        day: date.day,
        month: date.month,
        year: date.year,
        descriptionOfUser: description == '' ? 'M???c l????ng/ng??y' : description,
        soTien: int.parse(wage),
        description: 'Th??m nh??n vi??n',
        date: DateFormat('yyyyMMdd').format(date),
        dataJson: json.encode(Employee(
          name: name,
          description: description,
          wage: int.parse(wage),
          wageOld: int.parse(wage),
          dateUpLevel: DateFormat('yyyyMMdd').format(DateTime.now()),
        ),),
        employeeId: employeeId,
        dateTime: DateFormat('dd/MM/yyyy hh:mm').format(date),
      );
      _databaseService.insertLog(log);
    })
        : await _databaseService.updateEmployee(Employee(
            id: widget.employee!.id,
            name: name,
            description: description,
            wage: int.parse(wage),
            dateUpLevel: DateFormat('yyyyMMdd').format(DateTime.now()),
          ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.employee == null
            ? const Text('Th??m nh??n vi??n')
            : const Text('C???p nh???t nh??n vi??n'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'H??? v?? T??n',
                  label: Text('H??? v?? T??n')),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ghi ch??',
                  label: Text('Ghi ch??')),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _wageController,
              decoration: InputDecoration(
                prefixText: _currency,
                hintText: '0VN??',
                label: const Text('L????ng/Ng??y'),
              ),
              keyboardType: TextInputType.number,
              onChanged: (string) {
                string = _formatNumber(string.replaceAll('.', ''));
                _wageController.value = TextEditingValue(
                  text: string,
                  selection: TextSelection.collapsed(offset: string.length),
                );
              },
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: const Text(
                  'Ho??n th??nh',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
