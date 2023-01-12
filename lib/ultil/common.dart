import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';

import '../services/database_service.dart';



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

Future<void> initFirsCol(var sheetName) async {
  final gsheets = GSheets(_credentials);
  // // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(sheetId);
  //
  // // get worksheet by its title
  var sheet = ss.worksheetByTitle(sheetName);
  // // create worksheet if it does not exist yet
  sheet ??= await ss.addWorksheet(sheetName);
  //
  // // update cell at 'B2' by inserting string 'new'
  final DatabaseService _databaseService = DatabaseService();

  var firstColumn = ['Họ và Tên'];

  await _databaseService.findAllEmployees().then((employees) {

    for (var employee in employees) {
      firstColumn.add(employee.name);
    }

  });

  print("(createRowDayOfMonth)firstCol: "+firstColumn.toString());
  await sheet.values.insertColumn(1, firstColumn, fromRow: 2);
}


Future<void> updateGoogleSheet(var value, int row, int col, var sheetName) async {
  final gsheets = GSheets(_credentials);
  // // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(sheetId);
  //
  // // get worksheet by its title
  var sheet = ss.worksheetByTitle(sheetName);
  // // create worksheet if it does not exist yet
  sheet ??= await ss.addWorksheet(sheetName);

  //
  // // update cell at 'B2' by inserting string 'new'
  print("(updateGoogleSheet)insert: "+value.toString()+",row:"+row.toString()+",col:"+col.toString());
  await sheet.values.insertValue(value, column: col, row: row);

}

Future<void> updateGoogleSheetAndLog(var value, int row, int col, var sheetName) async {
  final gsheets = GSheets(_credentials);
  // // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(sheetId);
  //
  // // get worksheet by its title
  var sheet = ss.worksheetByTitle(sheetName);
  // // create worksheet if it does not exist yet
  sheet ??= await ss.addWorksheet(sheetName);

  var valueOl = '';
  await sheet.values.value(column: col, row: row).then((valueOld) {
    print("Value old: "+ valueOld);
    valueOl = valueOld;
  });

  //
  // // update cell at 'B2' by inserting string 'new'
  print("(updateGoogleSheetAndLog)insert: "+value.toString()+",row:"+row.toString()+",col:"+col.toString());
  await sheet.values.insertValue(value+"||||"+valueOl, column: col, row: row);

}

Future<void> createRowDayOfMonth(var sheetName) async {
  final gsheets = GSheets(_credentials);
  // // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(sheetId);
  //
  // // get worksheet by its title
  var sheet = ss.worksheetByTitle(sheetName);
  // // create worksheet if it does not exist yet
  sheet ??= await ss.addWorksheet(sheetName);
  //
  // // update cell at 'B2' by inserting string 'new'
  var firstRow = ['Ngày'];

  var numberDays = daysInMonth(DateTime.now().year, DateTime.now().month);

  for(int i = 1; i < numberDays; i++){
    firstRow.add(DateFormat('dd/MM/yyyy').format(DateTime(DateTime.now().year,DateTime.now().month, i)));
  }

  if(sheetName=="Luong") {
    firstRow.add("Lương tháng");
  }

  if(sheetName=="NgayCong") {
    firstRow.add("Số công đi làm");
  }

  print("(createRowDayOfMonth)firstRow: "+firstRow.toString());
  await sheet.values.insertRow(1, firstRow);
}

void openPickerWithCustomPickerTextStyle(BuildContext context, DateTime dateTime) {
  BottomPicker(
    items: const [
      Text('Tháng 1'),
      Text('Tháng 2'),
      Text('Tháng 3'),
      Text('Tháng 4'),
      Text('Tháng 5'),
      Text('Tháng 6'),
      Text('Tháng 7'),
      Text('Tháng 8'),
      Text('Tháng 9'),
      Text('Tháng 10'),
      Text('Tháng 11'),
      Text('Tháng 12'),
    ],
    dismissable: true,
    title: 'Chọn tháng hiển thị',
    titleStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    pickerTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 26
    ),
    closeIconColor: Colors.red,
    onSubmit: (item) {
      var month = item < 10 ? "0"+item.toString() : item.toString();
      var date = DateTime.parse(dateTime.year.toString()+""+month+"01");
      dateTime = date;
      print(item);
      print(date);
      print(dateTime);
    },
  ).show(context);
}

class MonthListView extends StatefulWidget {
  const MonthListView({Key? key, required this.onReload, required this.monthSelected}) : super(key: key);
  final Function(dynamic) onReload;
  final int monthSelected;

  @override
  _MonthListViewState createState() => _MonthListViewState();
}

class _MonthListViewState extends State<MonthListView> {

  final months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  var monthActive = DateTime.now().month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    monthActive = widget.monthSelected;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          return Container(
            margin: const EdgeInsets.only(right: 15,),
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  monthActive == month ? Colors.blue : Colors.white,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 13, bottom: 13,),
                child: Text(
                  'Tháng ' + month.toString(),
                  style: TextStyle(
                    color: monthActive == month ? Colors.white : Colors.black,
                  ),
                ),
              ),
              onPressed: () => setState(() {
                monthActive = month;
                widget.onReload(month);
              }),
            ),
          );
        },
      ),

      // ListView(
      //   scrollDirection: Axis.horizontal,
      //   children: <Widget>[
      //     OutlinedButton(
      //       style: ButtonStyle(
      //         backgroundColor: MaterialStateProperty.all<Color>(
      //           Colors.white,
      //         ),
      //       ),
      //       child: const Padding(
      //         padding: EdgeInsets.only(top: 13, bottom: 13,),
      //         child: Text(
      //           'Tháng 1',
      //           style: TextStyle(
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //       onPressed: () => setState(() {
      //
      //       }),
      //     ),
      //     const SizedBox(width: 15,),
      //     OutlinedButton(
      //       style: ButtonStyle(
      //         backgroundColor: MaterialStateProperty.all<Color>(
      //           Colors.white,
      //         ),
      //       ),
      //       child: const Padding(
      //         padding: EdgeInsets.only(top: 13, bottom: 13,),
      //         child: Text(
      //           'Tháng 2',
      //           style: TextStyle(
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //       onPressed: () => setState(() {
      //
      //       }),
      //     ),
      //     const SizedBox(width: 15,),
      //   ],
      // ),
    );
  }
}

