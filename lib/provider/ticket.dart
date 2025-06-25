// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ceni_fruit/model/ticket.dart';

// final ticketProvider =
//     StateNotifierProviderFamily<TicketNotifier, AsyncValue<List<Ticket>>, String>(
//       (ref, idOrder) => TicketNotifier(_idOrder: idOrder),
//     );

// class TicketNotifier extends StateNotifier<AsyncValue<List<Ticket>>> {
//   String _idOrder = "";
//   TicketNotifier({String idOrder = ""}) : super(const AsyncValue.loading()) {
//     _idUser = idUser;
//     loadTicket();
//   }

//   Future<List<Ticket>> loadTicket() async {
//     try {
//       state = const AsyncValue.loading();

//       var data = await rootBundle.loadString("assets/data/ticket.json");
//       var json = jsonDecode(data);

//       List<Ticket> tickets = (json["data"] as List)
//           .map((t) => Ticket.fromJson(t))
//           .toList();

//            if (_idUser.isNotEmpty) {
//         tickets = tickets.where((ticket) => ticket.seatNumber == _idUser).toList();
//       }

//       state = AsyncValue.data(tickets);
//       return tickets;
//     } catch (error, stackTrace) {
//       state = AsyncValue.error(error, stackTrace);
//       rethrow;
//     }
//   }

//   Future<void> refreshTicket() async {
//     loadTicket();
//   }
// }
