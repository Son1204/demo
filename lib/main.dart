// import 'dart:ffi';

import 'dart:math';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:gsheets/gsheets.dart';
import 'package:loadmore/loadmore.dart';
import 'package:test123/pages/excel_view_page.dart';

import 'common_widgets/employee_builder.dart';
import 'common_widgets/employee_in_day_builder.dart';
import 'common_widgets/report_builder.dart';
import 'models/employee.dart';
import 'pages/home_page.dart';
import 'package:cron/cron.dart';

import 'services/database_service.dart';


const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheets-372810",
  "private_key_id": "8991cc501fa73b907b22d264fd435cbfc0f388ae",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCI2FCMthh8yBgt\n1YGKETi66S5HVvuUDnAQulxy+RByBfhS2SMJ2fH4h02N3SHOjQbd7F0u4MXC/4s1\neY2y3ovEd6+LOnfKVpM5B7LTs/wGpVSCrehYm6oCY2ma2JNBS8kNiqvQhNzZ0x0O\nVGwXH25A8pXzW/OwqrkPwAVvGQcCUcrDZSY/M6af22r5A/tywwcC/zTzyOiME/uk\nsU7hFthvnlBUognMyPE0c/rShLQAbDG9sEi2WbKRCyB0B7UAA/tNbTEq7cCAoI0s\no7ugZVKqYCsnK1AFeGzhxuXRYYUWE21IzjEiKrQnl9X06JpFhs9kDEDqf2mELDT/\naqvzDeSJAgMBAAECggEAQZSlGaIk3xwHlmOVNoUlUlHwl0jEvUIkC6g8KO9apcJd\nrNqZs51qnGe/T4bTrkigq1ccmxwmOlq8LK7prPiBM/EFxCwLf4D5AiJB3boKRGcU\nNqJAUMKc+ZMJ56b1/xtiKWa1C3O44X0OljD4MiaicGaxXRTKlvZiRP2JvSHZ3Y6A\nuqgA73FmDJB3w3BxcMiIQbSeiwKvfhvLZl2e/gP1vguE/C5KZf5EEsK8dxTzY0FH\n9cqXYI327Nn63l1ezQqzVuPB77LuzVsxo6cRmgTuQFdD0E/OAIMMe9mAxoxdh5uF\n2SGOkjdnUPmg1NASKCKt5hb/4wcAW3F6uNi9bBmXPwKBgQC90mWFctG0f0/LwbpL\nOyijss9rw6phjx5OwicauaiE/HqJvecFpfSW+CErI9PVK6sFaazGOHQ6/Gsvtfey\nontgzthxfD0LGc4eGnBTWSfKHlDyGE2X+VqoxnsVLPB1Iba2+HJ8KMBL2jqLXvFP\ntRkupu2tkvNV8rudxDPjySKQ4wKBgQC4jbsNvnZRsFXrxz9pOIldSrXTY0XGIYKX\nqaZ9EzqzNOvxEuY+dPu2dYD0sntU1IucmS2L9kMkR5hkDw9zFcwfYuVKFuSHLv8T\nlRUe2qU5HTs1Q2CewatgRmX4ZNrtAwNUXPCgbHAD1ssfW55Q6oejHuYQv2tY7LxK\ngx8oiIsMowKBgGyN8P8DLcgicpjc3lP9rf0H2jUPvdVzCmsR/1j6SdRbqxwwnPiO\n8rSPjDBmmdMz2OcMiwEE8ft1tTqgvtnKr/Ip+H/WA/bgOA7hIdGYj/e3pKT+nwlF\nUcJpV6RBgfYKZLp4lMhKacY3M/nWPvxNXexfDFeSTVSerwrHVMF0mi7vAoGBAJzG\nwcVOLAL/Ei5mJ4cCISbgRY/agDZs1xxxYN5VjIMaDOjRDki2ZfI85Zx5Vm3c1PDl\n6xw/yg+yxlERviUcujdbcr66rc3s7YE8HyIDyWG4ZEi+AQE8MpJpm0wkmRnIenab\nMUqGc62/NPRhhx7j7O90WyqVAeMb0GRX+Qsc20qTAoGAK0yaOFcjB+azxTD9HRYm\nLOnTohN1irRf9xCFfLW776H1zUO1ifCSVT03eaqeAgbNwUCEelcIe62EL9y1/Ghy\nNuf8PlKrF7V5wksChwk+FiZrIxd886Cah1xXVTuPkA5IGYKy3NNA2/1y69fT3Rzn\nxkA/6MnaqXhtB9+HjZGiQTs=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets-372810@gsheets-372810.iam.gserviceaccount.com",
  "client_id": "105459039820153317868",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets-372810%40gsheets-372810.iam.gserviceaccount.com"
}
''';

const sheetId = '1I3KwQZFQGaSmj6J4DLRce1ZZdmQi4pdxkmOu8lCGxyY';

void main() async {
  final DatabaseService _databaseService = DatabaseService();
  final cron = Cron();

  cron.schedule(Schedule.parse('*/1 * * * *'), () async {
    print('every three minutes');
    // var findAllEmployees = _databaseService.findAllEmployees();
    //
    // findAllEmployees.then((value) {
    //   for (var emp in value) {
    //     _databaseService.findKyCongIdByEmployeeAndDateTime(emp.id!, DateTime.now()).then((kycong) {
    //       _databaseService.findChiTietKyCongByKyCongId(kycong.id!).then((chiTietKyCongs) {
    //         emp.chuaThanhToan = 0;
    //         for (var ct in chiTietKyCongs) {
    //           emp.chuaThanhToan += ct.thuNhapThucTe;
    //         }
    //         _databaseService.updateEmployee(emp);
    //       });
    //     });
    //   }
    // });
  });

  cron.schedule(Schedule.parse('8-11 * * * *'), () async {
    print('between every 8 and 11 minutes');
  });

  // final gsheets = GSheets(_credentials);
  // // fetch spreadsheet by its id
  // final ss = await gsheets.spreadsheet(sheetId);
  //
  // // get worksheet by its title
  // var sheet = ss.worksheetByTitle('example');
  // // create worksheet if it does not exist yet
  // sheet ??= await ss.addWorksheet('example');
  //
  // // update cell at 'B2' by inserting string 'new'
  // await sheet.values.insertValue('new', column: 2, row: 2);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      title: 'Flutter Clean Calendar Demo',
      home: MyNevBar(),
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
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    importFromExcel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Chấm công"),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: const Icon(Icons.notifications),
      //       onPressed: () => {},
      //     ),
      //   ],
      //   elevation: 0,
      // ),
      body: SafeArea(child: listOfColors[currentIndex],),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: DotNavigationBar(
          margin: EdgeInsets.only(left: 10, right: 10),
          currentIndex: currentIndex,
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          // enableFloatingNavBar: false,
          onTap: (index) {
            currentIndex = index;
            setState(() {

            });
          },
          items: [
            /// Home
            DotNavigationBarItem(
              icon: Icon(Icons.home),
              selectedColor: Color(0xff73544C),
            ),

            DotNavigationBarItem(
              icon: Icon(Icons.person),
              selectedColor: Color(0xff73544C),
            ),

            DotNavigationBarItem(
              icon: Icon(Icons.file_copy),
              selectedColor: Color(0xff73544C),
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
  CalendarAgendaController _calendarAgendaControllerNotAppBar =
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
            // fullCalendar: false,
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
            firstDate: DateTime.now().subtract(Duration(days: 1000)),
            lastDate: DateTime.now().add(Duration(days: 1200)),
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
