import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/service/paypal_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paypalServiceProvider = Provider<PaypalService>((ref) {
  final dio = ref.read(dioProvider);
  return PaypalService(dio);
});
