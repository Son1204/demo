import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test123/common_widgets/employee_builder.dart';
import 'package:test123/common_widgets/employee_wage_builder.dart';
import 'package:test123/models/employee.dart';
import 'package:test123/pages/employee_form_pay_page.dart';
import 'package:test123/pages/log_page_bonus.dart';
import 'package:test123/pages/log_page_pay.dart';

import '../models/log.dart';
import '../pages/employee_form_bonus_page.dart';
import '../pages/employee_form_up_level_form.dart';
import '../pages/log_page.dart';
import '../pages/pdf_view_page.dart';
import '../services/database_service.dart';
import '../ultil/common.dart';
import 'package:pdf/widgets.dart' as w;

class EmployeeDetailBuilder extends StatefulWidget {
  const EmployeeDetailBuilder(
      {Key? key, required this.employee, required this.selectedDate, required this.onReload})
      : super(key: key);
  final Employee employee;
  final DateTime selectedDate;
  final Function onReload;

  @override
  _EmployeeDetailBuilder createState() => _EmployeeDetailBuilder();
}

class _EmployeeDetailBuilder extends State<EmployeeDetailBuilder> {
  final DatabaseService _databaseService = DatabaseService();

  final pdf = w.Document();
  Future<Uint8List> getPDFData() async {
    return await pdf.save();
  }

  Log log = Log(
      day: DateTime.now().day,
      month: DateTime.now().month,
      year: DateTime.now().year,
      description: '',
      descriptionOfUser: '',
      date: DateFormat('yyyyMMdd').format(DateTime.now()),
      dataJson: '{}',
      employeeId: 0,
      dateTime: DateTime.now().toString(),
  );

  Future<void> _onDeleteEmployee() async {
    print("(_onDeleteEmployee)employeeId: " + widget.employee.id.toString());
    widget.employee.removed = 1;
    _databaseService.updateEmployee(widget.employee);

    Log log = Log(
      day: DateTime.now().day,
      month: DateTime.now().month,
      descriptionOfUser: "",
      soTien: 0,
      year: DateTime.now().year,
      description: "Nghỉ việc",
      date: DateFormat('yyyyMMdd').format(DateTime.now()),
      dataJson: json.encode(widget.employee),
      employeeId: widget.employee.id!,
      dateTime: DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now()),
    );
    _databaseService.insertLog(log);

    Navigator.pop(context);
  }

  int soTienDaThanhToanTrongThang = 0;
  double tongCongTrongThang = 0.0;
  int luongThang = 0;
  int soTienThuongPhuCap = 0;
  // int soTienChuaThanhToan = 0;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('vi').format(int.parse(s));
  var month = DateTime.now().month;
  late DateTime selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = widget.selectedDate;
    month = widget.selectedDate.month;

    loadData();
  }

  void loadData() {
    print("(loadData)employee_detail_builder");
    // _databaseService.findEmployee(widget.employee.id!).then((value) {
    //   // Cập nhật chua thanh toan khi cần
    //   soTienChuaThanhToan = value.chuaThanhToan;
    //   setState(() {});
    // });

    _databaseService.findLogsByEmployee(widget.employee.id!, 0).then((values) {
      log = values[0];
      setState(() {});
    });

    _databaseService
        .findBillsByEmployeeAndDateTime(widget.employee.id!, selectedDate)
        .then((values) {
      soTienDaThanhToanTrongThang = 0;
      for (var value in values) {
        soTienDaThanhToanTrongThang =
            soTienDaThanhToanTrongThang + value.soTien;
      }

      setState(() {});
    });

    _databaseService
        .findChiTietKyCongByEmployeeAndDate(widget.employee.id!, selectedDate)
        .then((values) {
      tongCongTrongThang = 0;
      luongThang = 0;
      for (var element in values) {
        if (element.chamCongNgay[0] == 1) {
          tongCongTrongThang += 1;
        }

        if (element.chamCongNgay[1] == 1 || element.chamCongNgay[2] == 1) {
          tongCongTrongThang += 0.5;
        }

        luongThang += element.thuNhapThucTe;
      }
      setState(() {});
    });

    _databaseService.findBonusByEmployeeAndDateTime(widget.employee.id!, selectedDate).then((values) {
      soTienThuongPhuCap = 0;
      for (var element in values) {
        soTienThuongPhuCap = soTienThuongPhuCap + element.soTien;
      }
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhân viên: ' + widget.employee.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonthListView(
                  onReload: (e) {
                    print(e);
                    month = e;
                    selectedDate = DateTime.parse(
                        widget.selectedDate.year.toString() +
                            (month < 10
                                ? '0' + month.toString()
                                : month.toString()) +
                            "01");
                    print(selectedDate);

                    loadData();
                  }, monthSelected: widget.selectedDate.month,
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Tổng số tiền chưa thanh toán: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      widget.employee.chuaThanhToan >= 0 ? TextButton(
                        onPressed: () {},
                        child: Text(
                          _formatNumber(
                              widget.employee.chuaThanhToan.toString()) +
                              'đ',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ) : TextButton(
                        onPressed: () {},
                        child: const Text('0đ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Ứng trước: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      widget.employee.chuaThanhToan < 0 ? TextButton(
                        onPressed: () {},
                        child: Text(
                          _formatNumber(
                              (widget.employee.chuaThanhToan * -1).toString()) +
                              'đ',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ) : TextButton(
                        onPressed: () {},
                        child: const Text('0đ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Tổng số tiền đã thanh toán: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          _formatNumber(
                                  widget.employee.daThanhToan.toString()) +
                              'đ',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.green),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Mức lương/ngày: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          _formatNumber(widget.employee.wage.toString()) + 'đ',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Mô tả: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(widget.employee.description == ''
                            ? '...'
                            : widget.employee.description),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.timer_sharp),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) => EmployeeWageBuilder(
                                        employee: widget.employee,
                                        selectedDate: selectedDate,
                                        onReload: () {
                                          loadData();
                                        },
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((_) => setState(() {}));
                            },
                            child: const Text(
                              "Ngày công",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(10),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          const Icon(Icons.monetization_on_sharp),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) => EmployeeFormPayPage(
                                        employee: widget.employee, onReload: () {
                                          loadData();
                                      },
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((_) => setState(() {}));
                            },
                            child: const Text(
                              "Thanh toán",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(10),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          const Icon(Icons.monetization_on_sharp),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) => EmployeeFormBonusPage(
                                        employee: widget.employee, onReload: () {
                                          loadData();
                                      },
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((_) => setState(() {}));
                            },
                            child: const Text(
                              "Phụ cấp/Thưởng",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(10),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.file_copy_sharp),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) => PdfViewPage(
                                        employee: widget.employee,
                                        selectedDate: selectedDate,
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((_) => setState(() {}));
                            },
                            child: const Text(
                              "Bảng lương",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(10),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          const Icon(Icons.add_chart),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) => EmployeeFormUpLevelPage(
                                        employee: widget.employee,
                                        onReload: () {
                                          loadData();
                                      },
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((_) => setState(() {}));
                            },
                            child: const Text(
                              "Điều chỉnh lương",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(10),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 5,
                  ),
                  margin: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                    // color: Colors.blue
                    color: Colors.deepOrangeAccent,
                  ),
                  child: Text(
                    "Thông tin tháng " + month.toString() + ': ',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                          left: 5,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_money_sharp),
                            Text(
                              "Lương tháng " +
                                  (month < 10
                                      ? '0' + month.toString()
                                      : month.toString()) +
                                  '/' +
                                  DateFormat("yyyy")
                                      .format(widget.selectedDate) +
                                  ': ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatNumber(luongThang.toString()) + 'đ',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                          left: 5,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_money_sharp),
                            Text(
                              "Số công đi làm tháng " +
                                  (month < 10
                                      ? '0' + month.toString()
                                      : month.toString()) +
                                  '/' +
                                  DateFormat("yyyy")
                                      .format(widget.selectedDate) +
                                  ': ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              tongCongTrongThang.toString() + ' công',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                          left: 5,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_money_sharp),
                            Text(
                              "Đã thanh toán trong tháng " +
                                  (month < 10
                                      ? '0' + month.toString()
                                      : month.toString()) +
                                  '/' +
                                  DateFormat("yyyy")
                                      .format(widget.selectedDate) +
                                  ': ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: ( ) {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (_) => LogPagePay(
                                      employee: widget.employee,
                                      selectedDate: selectedDate,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                )
                                    .then((_) => setState(() {}));
                              },
                              child: Text(
                                _formatNumber(
                                        soTienDaThanhToanTrongThang.toString()) +
                                    'đ',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                          left: 5,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.money_sharp),
                            Text(
                              "Phụ cấp/thưởng tháng " +
                                  (month < 10
                                      ? '0' + month.toString()
                                      : month.toString()) +
                                  '/' +
                                  DateFormat("yyyy")
                                      .format(selectedDate) +
                                  ': ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (_) => LogPageBonus(
                                      employee: widget.employee,
                                      selectedDate: selectedDate,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                )
                                    .then((_) => setState(() {}));
                              },
                              child: Text(
                                _formatNumber(soTienThuongPhuCap.toString()) + 'đ',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => LogPage(
                              employee: widget.employee,
                            ),
                            fullscreenDialog: true,
                          ),
                        )
                        .then((_) => setState(() {}));
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            top: 10,
                            left: 5,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.notifications),
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
                                    height: 4,
                                  ),
                                  Text('Ngày: ' + log.dateTime),
                                ],
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                log.descriptionOfUser == '' ? log.description : log.descriptionOfUser + ', ' + _formatNumber(log.soTien.toString())+'đ',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                widget.employee.removed == 0 ? TextButton(
                  onPressed: () {
                    _onDeleteEmployee();
                  },
                  child: Container(
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade100),
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                    // color: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: const Text(
                      'Nghỉ việc',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ) : TextButton(
                  onPressed: () {
                    widget.employee.removed = 0;
                    _databaseService.updateEmployee(widget.employee);

                    Log log = Log(
                      day: DateTime.now().day,
                      month: DateTime.now().month,
                      descriptionOfUser: "",
                      soTien: 0,
                      year: DateTime.now().year,
                      description: "Đi làm lại",
                      date: DateFormat('yyyyMMdd').format(DateTime.now()),
                      dataJson: json.encode(widget.employee),
                      employeeId: widget.employee.id!,
                      dateTime: DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now()),
                    );
                    _databaseService.insertLog(log);

                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade100),
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                    // color: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: const Text(
                      'Đi làm lại',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.onReload();
  }
}
