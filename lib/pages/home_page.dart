import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test123/common_widgets/employee_builder.dart';
import 'package:test123/models/employee.dart';
import 'package:test123/pages/employee_form_page.dart';

import '../common_widgets/breed_builder.dart';
import '../common_widgets/dog_builder.dart';
import '../models/breed.dart';
import '../models/dog.dart';
import '../services/database_service.dart';
import 'breed_form_page.dart';
import 'dog_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Dog>> _getDogs() async {
    return await _databaseService.dogs();
  }

  Future<List<Breed>> _getBreeds() async {
    return await _databaseService.breeds();
  }

  Future<List<Employee>> _getEmployee() async {
    return await _databaseService.findAllEmployees();
  }

  Future<void> _onDogDelete(Dog dog) async {
    await _databaseService.deleteDog(dog.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dog Database'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Dogs'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Breeds'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.of(context)
                //     .push(
                //   MaterialPageRoute(
                //     builder: (_) => const EmployeeFormPage(),
                //     fullscreenDialog: true,
                //   ),
                // )
                //     .then((_) => setState(() {}));

                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => EmployeeFormPage()))
                    .then((context) => setState(() {}));
              },
              child: Container(
                height: 45.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: const Text("Thêm nhân viên"),
              ),
            ),
            // DogBuilder(
            //   future: _getDogs(),
            //   onEdit: (value) {
            //     {
            //       Navigator.of(context)
            //           .push(
            //             MaterialPageRoute(
            //               builder: (_) => DogFormPage(dog: value),
            //               fullscreenDialog: true,
            //             ),
            //           )
            //           .then((_) => setState(() {}));
            //     }
            //   },
            //   onDelete: _onDogDelete,
            // ),
            // EmployeeBuilder(onEdit: (value) {
            //   {
            //     Navigator.of(context)
            //         .push(
            //       MaterialPageRoute(
            //         builder: (_) => EmployeeFormPage(employee: value),
            //         fullscreenDialog: true,
            //       ),
            //     )
            //         .then((_) => setState(() {}));
            //   }
            // }, onDetail: (Employee ) {  },),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => EmployeeFormPage(),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              heroTag: 'them nhan vien',
              child: const FaIcon(FontAwesomeIcons.plus),
            ),
          ],
        ),
      ),
    );
  }
}
