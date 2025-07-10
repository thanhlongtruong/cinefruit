import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/model/order.dart';
import 'package:ceni_fruit/model/ticket.dart';
import 'package:ceni_fruit/service/order_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  final dio = ref.read(dioProvider);
  return OrderService(dio);
});

final getOrderWithTicketIdUser =
    StateNotifierProvider<OrderProvider, AsyncValue<List<GetOrderWithTicket>>>((
      ref,
    ) {
      return OrderProvider(ref, ref.read(orderServiceProvider));
    });

class GetOrderWithTicket {
  Order order;
  List<Ticket> tickets;

  GetOrderWithTicket({required this.order, required this.tickets});
}

class OrderProvider
    extends StateNotifier<AsyncValue<List<GetOrderWithTicket>>> {
  final Ref ref;
  final OrderService orderService;

  OrderProvider(this.ref, this.orderService)
    : super(const AsyncValue.loading()) {
    loadTicket();
  }

  Future<void> loadTicket() async {
    try {
      state = const AsyncValue.loading();

      final getTicket = await orderService.getOrderWithTicket();
      final List<GetOrderWithTicket> orders =
          (getTicket["data"]["orders"] as List)
              .map(
                (order) => GetOrderWithTicket(
                  order: Order.fromJson(order),
                  tickets: (order["tickets"] as List)
                      .map((t) => Ticket.fromJson(t))
                      .toList(),
                ),
              )
              .toList();

      state = AsyncValue.data(orders);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
