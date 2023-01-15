import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:test123/models/employee.dart';

import '../pages/employee_form_page.dart';
import '../services/database_service.dart';
import 'employee_detail_builder.dart';

class EmployeeBuilderDeActive extends StatefulWidget {
  const EmployeeBuilderDeActive({
    Key? key,
  }) : super(key: key);

  @override
  _EmployeeBuilderDeActive createState() => _EmployeeBuilderDeActive();
}

class _EmployeeBuilderDeActive extends State<EmployeeBuilderDeActive> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Employee>> _getEmployee() async {
    return await _databaseService.findAllEmployees(1);
  }

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('vi').format(int.parse(s));
  var currentDate = DateFormat('dd/MM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhân viên đã nghỉ việc'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Employee>>(
        future: _getEmployee(),
        initialData: const [],
        builder: (context, snapshot) {
          if(snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Không có dữ liệu"),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final employee = snapshot.data![index];
                      return _buildEmployeeCard(employee, context);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmployeeCard(Employee employee, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (_) => EmployeeDetailBuilder(
                        employee: employee, selectedDate: DateTime.now(), onReload: () {},
                      ),
                      fullscreenDialog: true,
                    ),
                  )
                      .then((_) => setState(() {}));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      employee.description,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Hôm nay: ' + currentDate,
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Lương/Ngày: '),
                        Text(
                          _formatNumber(employee.wage.toString()) +
                              " VNĐ",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        const Text('Đã thanh toán: '),
                        Text(
                          _formatNumber(
                              employee.daThanhToan.toString()) +
                              " VNĐ",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        const Text('Chưa thanh toán: '),
                        Text(
                          _formatNumber(
                              employee.chuaThanhToan.toString()) +
                              " VNĐ",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
