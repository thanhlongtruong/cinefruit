import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/service/momo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final momoServiceProvider = Provider<MomoService>((ref) {
  final dio = ref.read(dioProvider);
  return MomoService(dio);
});
