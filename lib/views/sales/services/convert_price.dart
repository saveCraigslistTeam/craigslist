import 'package:intl/intl.dart';

final oCcy = NumberFormat("#,##0", "en_US");
String convertPrice(priceToConvert) {
  if (priceToConvert == 0) {
    return 'Free';
  }
  String priceString = '\$${oCcy.format(priceToConvert)}';
  String price = priceString.split('.')[0];
  return price;
}
