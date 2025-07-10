import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/service/payment_method_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ceni_fruit/model/payment_method.dart';

final PaymentMethodProviderService = Provider<PaymentMethodService>((ref) {
  final dio = ref.read(dioProvider);
  return PaymentMethodService(dio);
});

final paymentMethodNotifierProvider =
    StateNotifierProvider<
      PaymentMethodNotifier,
      AsyncValue<List<PaymentMethod>>
    >((ref) {
      return PaymentMethodNotifier(ref);
    });

class PaymentMethodNotifier
    extends StateNotifier<AsyncValue<List<PaymentMethod>>> {
  final Ref ref;

  PaymentMethodNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadPaymentMethod();
  }

  Future<List<PaymentMethod>> loadPaymentMethod() async {
    try {
      state = AsyncValue.loading();
      final result = await ref
          .read(PaymentMethodProviderService)
          .getPaymentMethod();
      if (result["success"]) {
        final paymentMethods = (result["payment_methods"] as List)
            .map((pm) => PaymentMethod.fromJson(pm))
            .toList();
        final paymentMethodsStateValid = paymentMethods
            .where((pm) => pm.state == true)
            .toList();

        state = AsyncValue.data(paymentMethodsStateValid);
        return paymentMethodsStateValid;
      } else {
        state = AsyncValue.error(result["message"], StackTrace.current);
        return [];
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return [];
    }
  }
}
