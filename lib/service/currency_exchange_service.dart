import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

String formatCurrencyVND(double value) {
  final currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'VND',
  );
  return currencyFormatter.format(value);
}

Future<Map<String, dynamic>> getExchangeRate() async {
  try {
    final url =
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    final vnd = data['usd']['vnd'];
    final vndAmount = formatCurrencyVND(vnd);

    return {
      "success": response.statusCode == 200,
      "vnd": response.statusCode == 200 ? vndAmount : null,
    };
  } catch (e) {
    return {
      "success": false,
      "message": "Lỗi không xác định: ${e.toString()}",
      "data": null,
    };
  }
}
