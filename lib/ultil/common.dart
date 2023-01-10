import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  const MonthListView({Key? key, required this.onReload}) : super(key: key);
  final Function(dynamic) onReload;

  @override
  _MonthListViewState createState() => _MonthListViewState();
}

class _MonthListViewState extends State<MonthListView> {

  final months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  var monthActive = DateTime.now().month;

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

