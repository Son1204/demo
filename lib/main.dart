
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:test123/models/google_sheet_config.dart';


import 'common_widgets/employee_builder.dart';
import 'common_widgets/employee_in_day_builder.dart';

import 'pages/table_view_page.dart';
import 'services/database_service.dart';
import 'ultil/common.dart';

void main() async {
  // final cron = Cron();

  // cron.schedule(Schedule.parse('*/1 * * * *'), () async {
  //   print('every three minutes');
  // });
  //
  // cron.schedule(Schedule.parse('8-11 * * * *'), () async {
  //   print('between every 8 and 11 minutes');
  // });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    print("reset app");
    var currentDate = DateTime.now();
    _databaseService.checkConfigGoogleSheet(currentDate.month, currentDate.year).then((value) {

      print("INIT GOOGLE SHEET: "+value.toString());
      if(value == false) {
        print("CALL GOOGLE SHEET");
        createRowDayOfMonth("NgayCong");
        createRowDayOfMonth("Luong");
        createRowDayOfMonth("Thuong/PhuCap");
        createRowDayOfMonth("ThanhToan");
        createRowDayOfMonth("DieuChinhLuong");

        initFirsCol("NgayCong");
        initFirsCol("Luong");
        initFirsCol("Thuong/PhuCap");
        initFirsCol("ThanhToan");
        initFirsCol("DieuChinhLuong");
        _databaseService.insertConfigGoogleSheet(GoogleSheetConfig(year: currentDate.year, month: currentDate.month));
      }

    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      title: 'App',
      home: const MyNevBar(),
    );
  }
}

class MyNevBar extends StatefulWidget {
  const MyNevBar({Key? key}) : super(key: key);

  @override
  _MyNevBarState createState() => _MyNevBarState();
}

class _MyNevBarState extends State<MyNevBar> {
  int currentIndex = 0;

  List listOfColors = [
    const CalendarScreen(),
    const EmployeeBuilder(),
    const SimpleTablePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: listOfColors[currentIndex],),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DotNavigationBar(
          margin: const EdgeInsets.only(left: 10, right: 10),
          currentIndex: currentIndex,
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          onTap: (index) {
            currentIndex = index;
            setState(() {

            });
          },
          items: [
            DotNavigationBarItem(
              icon: const Icon(Icons.home),
              selectedColor: const Color(0xff73544c),
            ),

            DotNavigationBarItem(
              icon: const Icon(Icons.person, size: 24,),
              selectedColor: const Color(0xff73544C),
            ),

            DotNavigationBarItem(
              icon: const Icon(Icons.file_copy),
              selectedColor: const Color(0xff73544C),
            ),

          ],
        ),
      ),
    );
  }
}

Future<bool> _doNastyStuffsBeforeExit() async {
  // Since this is an async method, anything you do here will not block UI thread
  // So you should inform user there is a work need to do before exit, I recommend SnackBar

  // Do your pre-exit works here...

  // also, you must decide whether the app should exit or not after the work above, by returning a future boolean value:
  print("luu data truoc khi thoat exit app");
  return Future<bool>.value(true); // this will close the app,
  // return Future<bool>.value(
  // false); // and this will prevent the app from exiting (by tapping the back button on home route)
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarAgendaController _calendarAgendaControllerNotAppBar =
      CalendarAgendaController();
  late DateTime _selectedDateNotAppBBar;

  @override
  void initState() {
    super.initState();
    _selectedDateNotAppBBar = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          CalendarAgenda(
            controller: _calendarAgendaControllerNotAppBar,
            selectedDayPosition: SelectedDayPosition.center,
            leading: SizedBox(
              child: TextButton(
                onPressed: () {
                  _calendarAgendaControllerNotAppBar.goToDay(DateTime.now());
                },
                child: const Text(
                  "Hôm nay",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            locale: 'vi',
            weekDay: WeekDay.long,
            fullCalendarDay: WeekDay.short,
            selectedDateColor: Colors.blue.shade900,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 1000)),
            lastDate: DateTime.now().add(const Duration(days: 1200)),
            onDateSelected: (date) {
              setState(() {
                _selectedDateNotAppBBar = date;
              });
            },
          ),
          Flexible(
            child: EmployeeInDayBuilder(
              dateTime: _selectedDateNotAppBBar,
            ),
            flex: 3,
          )
        ],
      )),
    );
  }
}
