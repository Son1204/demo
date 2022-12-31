import 'package:flutter/material.dart';
import 'package:test123/common_widgets/employee_builder.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  _EmployeePage createState() => _EmployeePage();
}

class _EmployeePage extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return EmployeeBuilder();
  }
}
