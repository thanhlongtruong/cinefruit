import 'dart:ui';

import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/convert_time.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/style_button.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/widget_not_loggedin.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/model/booking.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/food_drink.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/params_pay_page.dart';
import 'package:ceni_fruit/model/payment_method.dart';
import 'package:ceni_fruit/model/room.dart';
import 'package:ceni_fruit/model/ticket.dart';
import 'package:ceni_fruit/provider/holding_seat_provider.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:ceni_fruit/provider/order_provider.dart';
import 'package:ceni_fruit/provider/payment_method_provider.dart';
import 'package:ceni_fruit/provider/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown/slide_countdown.dart';

class BookedTicketPage extends ConsumerStatefulWidget {
  const BookedTicketPage({super.key});

  @override
  ConsumerState<BookedTicketPage> createState() => _BookedTicketPageState();
}

class _BookedTicketPageState extends ConsumerState<BookedTicketPage> {
  late HoldingSeatUserAndDiff? holdingSeatUser;

  Widget buildItem(data, List<PaymentMethod> paymentMethodState) {
    DateTime parseDate(createdAt) {
      return DateTime.parse(createdAt).toLocal();
    }

    final style = TextStyle(
      color: colorTextApp,
      letterSpacing: letterSpacingSmall,
      fontWeight: fontWeightNormal,
      fontSize: textfontSizeNote,
    );

    if (data is GetOrderWithTicket) {
      final GetOrderWithTicket orderWithTicket = data;
      final formatted = DateFormat(
        'dd/MM/yyyy HH:mm:ss',
      ).format(parseDate(orderWithTicket.order.createdAt));

      Color colorPaymentStatus =
          orderWithTicket.order.paymentStatus == "Đã thanh toán"
          ? colorTextSuccess
          : colorTextWarning;
      final Movie movie = orderWithTicket.order.idMovieRoom.idMovie;
      final MovieRoom movieRoom = orderWithTicket.order.idMovieRoom;
      final Room room = orderWithTicket.order.idMovieRoom.idRoom;
      final Cinema cinema = orderWithTicket.order.idMovieRoom.idRoom.idCinema;
      final List<Ticket> tickets = orderWithTicket.tickets;

      final time = convertTime(orderWithTicket.order.expiredAt ?? "");

      List<Map<String, dynamic>> totalChooseFoodDrink = [];
      for (var fd in orderWithTicket.order.foodDrinks!) {
        String id = fd["_id"];
        if (!totalChooseFoodDrink.any((fdc) => fdc["id"] == id)) {
          totalChooseFoodDrink.add({
            "id": FoodDrink.fromJson(fd["id"]),
            "quantity": fd["quantity"],
          });
        }
      }
      return Padding(
        padding: const EdgeInsets.all(spacingMedium),
        child: ClipRRect(
          borderRadius: borderRadiusCardBig,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                child: Container(color: Colors.black.withOpacity(0.15)),
              ),
              Container(
                padding: const EdgeInsets.all(spacingMedium),
                child: Column(
                  spacing: spacingSmall,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (orderWithTicket.order.expiredAt != null && time != null)
                      Row(
                        children: [
                          Text(
                            "Sau",
                            style: TextStyle(
                              color: colorPaymentStatus,
                              letterSpacing: letterSpacingSmall,
                              fontWeight: fontWeightMedium,
                              fontSize: textfontSizeApp,
                            ),
                          ),
                          SlideCountdown(
                            key: ValueKey(orderWithTicket.order.expiredAt),
                            icon: Icon(
                              Icons.timer_outlined,
                              size: iconfontSizeNormal,
                              color: colorIcon,
                            ),
                            slideDirection: SlideDirection.up,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            duration: Duration(
                              hours: time["hours"] ?? 0,
                              minutes: time["minutes"]!,
                              seconds: time["seconds"]!,
                            ),
                            style: TextStyle(
                              color: colorTextApp,
                              letterSpacing: letterSpacingSmall,
                              fontWeight: fontWeightMedium,
                              fontSize: textfontSizeApp,
                            ),
                            onDone: () async {
                              await ref
                                  .read(getOrderWithTicketIdUser.notifier)
                                  .loadTicket();
                            },
                          ),
                          Text(
                            "sẽ hoàn tác.",
                            style: TextStyle(
                              color: colorPaymentStatus,
                              letterSpacing: letterSpacingSmall,
                              fontWeight: fontWeightMedium,
                              fontSize: textfontSizeApp,
                            ),
                          ),
                        ],
                      ),
                    Text("Phim : ${movie.name}", style: style),
                    Text(
                      "Rạp : ${cinema.name} (${cinema.address})",
                      style: style,
                    ),
                    Text(
                      "Số lượng vé : ${orderWithTicket.tickets.length}",
                      style: style,
                    ),
                    Text("Ngày đặt : $formatted", style: style),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Trạng thái : ", style: style),
                          TextSpan(
                            text: "${orderWithTicket.order.paymentStatus}",
                            style: TextStyle(
                              color: colorPaymentStatus,
                              letterSpacing: letterSpacingSmall,
                              fontWeight: fontWeightMedium,
                              fontSize: textfontSizeApp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      spacing: spacingMedium,
                      children: [
                        customElevatedButtonBgTransparent(
                          () {
                            final selectedSeats = tickets
                                .map((ticket) => ticket.seatNumber)
                                .toList();
                            List<String> listWithoutNulls = selectedSeats
                                .whereType<String>()
                                .toList();

                            ParamsPayPage params = ParamsPayPage(
                              movie: movie,
                              cinema: cinema,
                              room: room,
                              selectedTime: orderWithTicket.order.time!,
                              movieRoom: movieRoom,
                              paymentMethods: paymentMethodState,
                              seatUser: null,
                              totalChooseFoodDrink: totalChooseFoodDrink,
                              selectedSeats: listWithoutNulls,
                              price: orderWithTicket.order.price!,
                              typeInformationThisPage:
                                  orderWithTicket.order.expiredAt != null &&
                                      time != null
                                  ? "page_payment"
                                  : "review",
                            );

                            NavigationHelper.goToPay(params: params);
                          },
                          Text(
                            orderWithTicket.order.expiredAt == null &&
                                    time == null
                                ? "Xem chi tiết"
                                : "Thanh toán",
                            style: TextStyle(
                              fontWeight: fontWeightNormal,
                              color: hexColorInformationSpecial,
                              letterSpacing: letterSpacingSmall,
                              fontSize: textfontSizeNote,
                            ),
                          ),
                        ),

                        if (orderWithTicket.order.expiredAt != null &&
                            time != null)
                          customElevatedButtonBgTransparent(
                            () async {
                              Get.dialog(
                                Center(child: circularProgress),
                                barrierDismissible: false,
                              );

                              final resultDelOrderWithTicket = await ref
                                  .read(orderServiceProvider)
                                  .delOrderWithTicket(
                                    orderWithTicket.order.idOrder!,
                                  );

                              if (resultDelOrderWithTicket["success"]) {
                                final resultUndoSeat = await ref
                                    .read(holdingSeatServiceProvider)
                                    .undoSeat(
                                      holdingSeatUser!
                                          .holdingSeat!
                                          .idHoldingSeat!,
                                    );

                                if (!resultUndoSeat["success"]) {
                                  showSnackbar(
                                    title: "Vé",
                                    message:
                                        resultDelOrderWithTicket["message"],
                                    type: "error",
                                  );
                                  return;
                                }

                                await ref
                                    .read(holdingSeatNofierProvider.notifier)
                                    .getHoldingSeatUser();
                                await ref
                                    .read(getOrderWithTicketIdUser.notifier)
                                    .loadTicket();
                              }
                              if (Get.isDialogOpen == true) {
                                Get.back();
                              }
                              if (!resultDelOrderWithTicket["success"]) {
                                showSnackbar(
                                  title: "Vé",
                                  message: resultDelOrderWithTicket["message"],
                                  type: "error",
                                );
                                return;
                              }
                            },
                            Text(
                              "Hoàn tác",
                              style: TextStyle(
                                fontWeight: fontWeightNormal,
                                color: hexColorInformationSpecial,
                                letterSpacing: letterSpacingSmall,
                                fontSize: textfontSizeNote,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (data is HoldingSeatUserAndDiff) {
      final HoldingSeatUserAndDiff holdingSeatUserAndDiff = data;

      final Movie movie =
          holdingSeatUserAndDiff.holdingSeat?.idMovieRoom.idMovie;
      final MovieRoom movieRoom =
          holdingSeatUserAndDiff.holdingSeat?.idMovieRoom;
      final Room room = holdingSeatUserAndDiff.holdingSeat?.idMovieRoom.idRoom;
      final Cinema cinema =
          holdingSeatUserAndDiff.holdingSeat?.idMovieRoom.idRoom.idCinema;

      final time = convertTime(
        holdingSeatUserAndDiff.holdingSeat?.expiredAt ?? "",
      );

      return Padding(
        padding: const EdgeInsets.all(spacingMedium),
        child: ClipRRect(
          borderRadius: borderRadiusCardBig,
          child: Stack(
            // 0993945045
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                child: Container(color: Colors.black.withOpacity(0.15)),
              ),
              Container(
                padding: const EdgeInsets.all(spacingMedium),
                child: Column(
                  spacing: spacingSmall,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (holdingSeatUserAndDiff.holdingSeat?.expiredAt != null &&
                        time != null)
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: colorTextWarning,
                            letterSpacing: letterSpacingSmall,
                            fontWeight: fontWeightMedium,
                            fontSize: textfontSizeApp,
                          ),
                          children: [
                            const TextSpan(text: "Sau"),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: SlideCountdown(
                                key: ValueKey(
                                  holdingSeatUserAndDiff.holdingSeat?.expiredAt,
                                ),
                                icon: Icon(
                                  Icons.timer_outlined,
                                  size: iconfontSizeNormal,
                                  color: colorIcon,
                                ),
                                slideDirection: SlideDirection.up,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                duration: Duration(
                                  hours: time["hours"] ?? 0,
                                  minutes: time["minutes"]!,
                                  seconds: time["seconds"]!,
                                ),
                                style: TextStyle(
                                  color: colorTextApp,
                                  letterSpacing: letterSpacingSmall,
                                  fontWeight: fontWeightMedium,
                                  fontSize: textfontSizeApp,
                                ),
                                onDone: () async {
                                  await ref
                                      .read(holdingSeatNofierProvider.notifier)
                                      .getHoldingSeatUser();
                                },
                              ),
                            ),
                            const TextSpan(text: "sẽ hoàn tác giữ ghế."),
                          ],
                        ),
                      ),
                    Text("Phim : ${movie.name}", style: style),
                    Text(
                      "Rạp : ${cinema.name} (${cinema.address})",
                      style: style,
                    ),
                    RichText(
                      text: TextSpan(
                        style: style,
                        children: [
                          const TextSpan(text: "Ghế đang giữ : "),
                          ...holdingSeatUserAndDiff.holdingSeat!.selectedSeat!
                              .map((s) => TextSpan(text: "$s, ")),
                        ],
                      ),
                    ),

                    Wrap(
                      spacing: spacingMedium,
                      children: [
                        customElevatedButtonBgTransparent(
                          () {
                            Booking params = Booking(
                              movie: movie,
                              movieRoom: movieRoom,
                              cinema: cinema,
                              room: room,
                              seatUser: holdingSeatUserAndDiff.holdingSeat,
                              seatsDiff: holdingSeatUserAndDiff.seatsDiff,
                              booked: [],
                            );

                            NavigationHelper.goToBooking(booking: params);
                          },
                          Text(
                            "Tiếp tục",
                            style: TextStyle(
                              fontWeight: fontWeightNormal,
                              color: hexColorInformationSpecial,
                              letterSpacing: letterSpacingSmall,
                              fontSize: textfontSizeNote,
                            ),
                          ),
                        ),
                        customElevatedButtonBgTransparent(
                          () async {
                            try {
                              Get.dialog(
                                Center(child: circularProgress),
                                barrierDismissible: false,
                              );

                              final data = await ref
                                  .read(holdingSeatServiceProvider)
                                  .undoSeat(
                                    holdingSeatUserAndDiff
                                        .holdingSeat!
                                        .idHoldingSeat!,
                                  );

                              await ref
                                  .read(holdingSeatNofierProvider.notifier)
                                  .getHoldingSeatUser();

                              if (Get.isDialogOpen == true) {
                                Get.back();
                              }
                              if (!data["success"]) {
                                showSnackbar(
                                  title: "Hoàn tác giữ Ghế",
                                  message: data["message"],
                                  type: "error",
                                );
                                return;
                              }
                              setState(() {});
                            } catch (error) {
                              if (Get.isDialogOpen == true) {
                                Get.back();
                              }
                              showSnackbar(
                                title: "Lỗi hệ thống",
                                message: "$error",
                                type: "error",
                              );
                            }
                          },
                          Text(
                            "Hoàn tác",
                            style: TextStyle(
                              fontWeight: fontWeightNormal,
                              color: hexColorInformationSpecial,
                              letterSpacing: letterSpacingSmall,
                              fontSize: textfontSizeNote,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final background = ref.read(backgroundMovieHot.notifier).state;
    final userProfileState = ref.watch(userProfile);
    final stateOrderWithTicket = ref.watch(getOrderWithTicketIdUser);
    final stateHoldingSeat = ref.watch(holdingSeatNofierProvider);
    final paymentMethod = ref.watch(paymentMethodNotifierProvider);

    if (userProfileState.value == null) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Lịch sử vé", style: tilteStyleApp),
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: colorTextApp),
          centerTitle: false,
        ),
        backgroundColor: bgColorApp,
        body: Stack(
          children: [
            if (background.isNotEmpty) ...backgroundApp(background),
            SafeArea(
              child: Center(
                child: Column(
                  spacing: spacingMedium,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vui lòng đăng nhập để xem được lịch sử vé.",
                      style: TextStyle(
                        color: colorTextApp,
                        fontSize: textfontSizeApp,
                        letterSpacing: letterSpacingSmall,
                        fontWeight: fontWeightNormal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    notLoggedinYet(context, "/homescreen_booked"),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      if (stateHoldingSeat.isLoading ||
          stateOrderWithTicket.isLoading ||
          paymentMethod.isLoading) {
        return buildLoadingScreen();
      } else if (stateHoldingSeat.hasError) {
        return buildErrorScreen(
          stateHoldingSeat.error,
          stateHoldingSeat.stackTrace,
          () async => await ref
              .read(holdingSeatNofierProvider.notifier)
              .getHoldingSeatUser(),
        );
      } else if (stateOrderWithTicket.hasError) {
        return buildErrorScreen(
          stateOrderWithTicket.error,
          stateOrderWithTicket.stackTrace,
          () async =>
              await ref.read(getOrderWithTicketIdUser.notifier).loadTicket(),
        );
      } else if (paymentMethod.hasError) {
        return buildErrorScreen(
          paymentMethod.error,
          paymentMethod.stackTrace,
          () async => await ref
              .read(paymentMethodNotifierProvider.notifier)
              .loadPaymentMethod(),
        );
      }

      final holdingSeatUserAndDiff = stateHoldingSeat.value;
      final dataOrderWithTicket = stateOrderWithTicket.value;
      final paymentMethodState = paymentMethod.value;
      holdingSeatUser = stateHoldingSeat.value;

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Lịch sử vé", style: tilteStyleApp),
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: colorTextApp),
          centerTitle: false,
        ),
        backgroundColor: bgColorApp,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (background.isNotEmpty) ...backgroundApp(background),
            SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(holdingSeatNofierProvider.notifier)
                      .getHoldingSeatUser();

                  await ref
                      .read(getOrderWithTicketIdUser.notifier)
                      .loadTicket();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (holdingSeatUserAndDiff?.holdingSeat != null &&
                        dataOrderWithTicket!.any(
                          (o) => o.order.expiredAt != null,
                        ))
                      buildItem(
                        holdingSeatUserAndDiff,
                        paymentMethodState ?? [],
                      ),

                    if (dataOrderWithTicket!.isEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(
                          child: Text(
                            "Chưa có vé nào được đặt.",
                            style: TextStyle(
                              color: colorTextApp,
                              fontSize: textfontSizeApp,
                              letterSpacing: letterSpacingSmall,
                              fontWeight: fontWeightNormal,
                            ),
                          ),
                        ),
                      )
                    else
                      ...dataOrderWithTicket.map(
                        (t) => buildItem(t, paymentMethodState ?? []),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
