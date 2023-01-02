import 'package:flutter/material.dart';
import 'package:test123/common_widgets/employee_wage_builder.dart';
import 'package:test123/common_widgets/report_builder.dart';
import 'package:test123/models/employee.dart';
import 'package:test123/pages/employee_form_pay_page.dart';

import '../pages/employee_form_up_level_form.dart';
import '../pages/log_page.dart';
import '../services/database_service.dart';

class EmployeeDetailBuilder extends StatefulWidget {
  const EmployeeDetailBuilder({Key? key, required this.employee})
      : super(key: key);
  final Employee employee;

  @override
  _EmployeeDetailBuilder createState() => _EmployeeDetailBuilder();
}

class _EmployeeDetailBuilder extends State<EmployeeDetailBuilder> {

  final DatabaseService _databaseService = DatabaseService();

  Future<void> _onDeleteEmployee() async {

    _databaseService.deleteEmployee(widget.employee.id!);

    Navigator.pop(context);
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
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text("Thống kê ngày: "),
                      const Icon(Icons.attach_money_sharp),
                      TextButton(
                        onPressed: () {},
                        child: const Text("300.000 vnđ"),
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
                                          employee: widget.employee),
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((_) => setState(() {}));
                            },
                            child: const Text("Ngày công"),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(10),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
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
                                        employee: widget.employee,
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((_) => setState(() {}));
                            },
                            child: const Text("Thanh toán"),
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
                          const Icon(Icons.file_copy_sharp),
                          TextButton(
                            onPressed: () {
                              generateInvoice(widget.employee);
                            },
                            child: const Text("Bảng lương"),
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
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((_) => setState(() {}));
                            },
                            child: const Text("Điều chỉnh lương"),
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
                  child: const Text(
                    "Chu kỳ lương tháng",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Lương tháng 12: 1.500.00 vnđ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Hôm nay:'),
                              ],
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Thanh toán lương tháng 12: 1.500.00 vnđ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Hôm nay:'),
                              ],
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Phụ cấp/thưởng tháng 12: 1.500.00 vnđ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Hôm nay:'),
                              ],
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
                              const Icon(Icons.attach_money_sharp),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Thông báo",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Hôm nay:'),
                                ],
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text("Vừa được tăng lương"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _onDeleteEmployee();
                  },
                  child: Container(
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
                ),
              ],
            )),
      ),
    );
  }
}
