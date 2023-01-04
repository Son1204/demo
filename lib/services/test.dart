import 'package:intl/intl.dart';
import 'package:quiver/time.dart';

void main() {
  print(DateFormat('yyyyMMdd').format(DateTime.now()));
  print(daysInMonth(2023, 2));
}
