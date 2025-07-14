import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

String formatCurrencyVND(double value) {
  final currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'VND',
  );
  return currencyFormatter.format(value.round());
}

String formatCurrencyUSD(double value) {
  final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '');
  return '${currencyFormatter.format(value)} USD';
}

double currencyVND(String str) {
  return double.tryParse(str.replaceAll(RegExp(r'[^\d]'), "")) ?? 0;
}

Future<Map<String, dynamic>> getExchangeRate() async {
  try {
    final url =
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/vnd.json';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    final usd = data['vnd']['usd'];

    return {
      "success": response.statusCode == 200,
      "usd": response.statusCode == 200 ? usd : null,
    };
  } catch (e) {
    return {
      "success": false,
      "message": "Lỗi không xác định: ${e.toString()}",
      "data": null,
    };
  }
}
