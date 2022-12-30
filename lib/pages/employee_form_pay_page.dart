import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test123/models/bill.dart';
import '../models/employee.dart';
import '../services/database_service.dart';

class EmployeeFormPayPage extends StatefulWidget {
  const EmployeeFormPayPage({Key? key, this.employee}) : super(key: key);
  final Employee? employee;

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

    // lưu thanh toán
    Bill bill = Bill(
      soTien: soTien,
      description: description,
      employeeId: widget.employee!.id!,
      day: date.day,
      month: date.month,
      year: date.year,
      date: DateFormat('dd-MM-yyyy hh:mm').format(date),
    );
    _databaseService.insertBill(bill);

    // trừ thông tin chưa thanh toán, thứ tự trừ tháng trước sau đó đến tổng
    widget.employee!.chuaThanhToan = widget.employee!.chuaThanhToan - soTien;

    // cập nhật đã thanh toán
    widget.employee!.daThanhToan = widget.employee!.daThanhToan + soTien;

    _databaseService.updateEmployee(widget.employee!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Scaffold(
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
                                widget.employee!.chuaThanhToan.toString()) +
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
                  TextField(
                    controller:
                        dateinput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Ngày thanh toán" //label text of field
                        ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
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
                  Row(
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
                  ),
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
        ),
      ),
    );
  }
}
