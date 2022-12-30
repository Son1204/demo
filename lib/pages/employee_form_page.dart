import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';
import '../services/database_service.dart';

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
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
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
        ?
    await _databaseService
        .insertEmployee(Employee(name: name, description: description, wage: int.parse(wage)))
    : await _databaseService
        .updateEmployee(Employee(id: widget.employee!.id,
        name: name, description: description, wage: int.parse(wage)));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.employee == null ? const Text('Thêm nhân viên') : const Text('Cập nhật nhân viên'),
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
                hintText: 'Họ và Tên',
                label: Text('Họ và Tên')
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ghi chú',
                label: Text('Ghi chú')
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _wageController,
              decoration: InputDecoration(prefixText: _currency,
                hintText: '0VNĐ',
                  label: const Text('Lương/Ngày'),
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
                  'Hoàn thành',
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
