import 'package:intl/intl.dart';

String convertDate(timeStamp) {
  var date = DateTime.parse(timeStamp.toString());
  final DateFormat formatter = DateFormat('EEEE, MMMM d, y');
  return formatter.format(date);
}
