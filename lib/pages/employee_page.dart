import 'package:flutter/material.dart';
import 'package:test123/common_widgets/employee_builder.dart';
import 'package:test123/common_widgets/employee_detail_builder.dart';
import 'package:test123/pages/employee_form_page.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  _EmployeePage createState() => _EmployeePage();
}

class _EmployeePage extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return EmployeeBuilder(
        // onEdit: (value) {
        //   {
        //     Navigator.of(context)
        //         .push(
        //           MaterialPageRoute(
        //             builder: (_) => EmployeeFormPage(employee: value),
        //             fullscreenDialog: true,
        //           ),
        //         )
        //         .then((_) => setState(() {}));
        //   }
        // },
        // onDetail: (employee) {
        //   Navigator.of(context)
        //       .push(
        //         MaterialPageRoute(
        //           builder: (_) => EmployeeDetailBuilder(employee: employee),
        //           fullscreenDialog: true,
        //         ),
        //       )
        //       .then((_) => setState(() {})
        // );
        // },
        );
  }
}
