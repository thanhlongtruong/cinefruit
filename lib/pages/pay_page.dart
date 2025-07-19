import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/convert_time.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/model/params_pay_page.dart';
import 'package:ceni_fruit/model/holding_seat.dart';
import 'package:ceni_fruit/model/payment_method.dart';
import 'package:ceni_fruit/provider/order_provider.dart';
import 'package:ceni_fruit/provider/payment_method_provider.dart';
import 'package:ceni_fruit/provider/paypal_provider.dart';
import 'package:ceni_fruit/provider/momo_provider.dart';
import 'package:ceni_fruit/service/currency_exchange_service.dart';
import 'package:ceni_fruit/ticket_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:get/get.dart';

class PayPage extends ConsumerStatefulWidget {
  final ParamsPayPage paramsPayPage;
  const PayPage({super.key, required this.paramsPayPage});

  @override
  ConsumerState<PayPage> createState() => _PayPageState();
}

class _PayPageState extends ConsumerState<PayPage> {
  late HoldingSeat? seatUser;
  late List<PaymentMethod> paymentMethods;

  String price = "";
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    seatUser = widget.paramsPayPage.seatUser;
    paymentMethods = widget.paramsPayPage.paymentMethods;
    price = widget.paramsPayPage.price;
    selectedPaymentMethod = widget.paramsPayPage.selectedPaymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    final time = convertTime(seatUser?.expiredAt ?? "");
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColorApp,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.paramsPayPage.typeInformationThisPage == "review"
              ? "Thông tin vé"
              : "Thanh toán",
          style: tilteStyleApp,
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: colorTextApp),
        bottom: seatUser != null && time != null
            ? PreferredSize(
                preferredSize: Size.fromHeight(11),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: bgColorApp,
                    borderRadius: borderRadiusButton,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Thời gian giữ ghế:",
                        style: TextStyle(
                          color: colorTextApp,
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightMedium,
                          fontSize: textfontSizeNote,
                        ),
                      ),
                      SlideCountdown(
                        key: ValueKey(seatUser?.expiredAt),
                        icon: Icon(
                          Icons.timer_outlined,
                          size: iconfontSizeNormal,
                          color: colorIcon,
                        ),
                        slideDirection: SlideDirection.up,
                        decoration: BoxDecoration(color: Colors.transparent),
                        duration: Duration(
                          hours: time["hours"]!,
                          minutes: time["minutes"]!,
                          seconds: time["seconds"]!,
                        ),
                        style: TextStyle(
                          color: colorTextApp,
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightMedium,
                          fontSize: textfontSizeNote,
                        ),
                        onDone: () {
                          setState(() {
                            seatUser = null;
                          });
                          NavigationHelper.goBack();
                        },
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ...backgroundApp(widget.paramsPayPage.movie.urlImage!),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                right: spacingMedium,
                left: spacingMedium,
                top: spacingMedium,
              ),
              child: Column(
                spacing: spacingMedium,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: spacingLarge,
                      children: List.generate(
                        widget.paramsPayPage.selectedSeats.length,
                        (index) => ticketShape(
                          index + 1,
                          widget.paramsPayPage.selectedSeats[index],
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: informationOrder()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ticketShape(int index, String seat) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.transparent,
        width: 350,
        height: 180,
        child: Stack(
          children: [
            CustomPaint(
              painter: TicketShape(),
              child: SizedBox(width: 350, height: 180),
            ),
            Row(
              children: [
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Center(
                      child: Text(
                        "Ticket# $index",
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightMedium,
                          fontSize: textfontSizeApp,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(spacingSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: spacingSmall,
                      children: [
                        Text(
                          "Phim: ${widget.paramsPayPage.movie.name}",
                          style: TextStyle(
                            color: hexColorTextBlack,
                            letterSpacing: letterSpacingSmall,
                            fontWeight: fontWeightMedium,
                            fontSize: textfontSizeApp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),

                        Row(
                          spacing: spacingTiny,
                          children: [
                            Text(
                              "Phòng: ${widget.paramsPayPage.room.roomNumber}",
                              style: TextStyle(
                                color: hexColorTextBlack,
                                letterSpacing: letterSpacingSmall,
                                fontWeight: fontWeightMedium,
                                fontSize: textfontSizeApp,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              ", ghế: $seat",
                              style: TextStyle(
                                color: hexColorTextBlack,
                                letterSpacing: letterSpacingSmall,
                                fontWeight: fontWeightMedium,
                                fontSize: textfontSizeApp,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        Text(
                          "Suất: ${widget.paramsPayPage.selectedTime} ${widget.paramsPayPage.movieRoom.date}",
                          style: TextStyle(
                            color: hexColorTextBlack,
                            letterSpacing: letterSpacingSmall,
                            fontWeight: fontWeightMedium,
                            fontSize: textfontSizeApp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          "Thời lượng: ${widget.paramsPayPage.movie.duration}",
                          style: TextStyle(
                            color: hexColorTextBlack,
                            letterSpacing: letterSpacingSmall,
                            fontWeight: fontWeightMedium,
                            fontSize: textfontSizeApp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget informationOrder() {
    return RefreshIndicator(
      onRefresh: () async {
        final navigator = Navigator.of(context);
        try {
          Get.dialog(
            Center(child: circularProgress),
            barrierDismissible: false,
          );
          final state = await ref
              .read(paymentMethodNotifierProvider.notifier)
              .loadPaymentMethod();
          setState(() {
            paymentMethods = state;
          });
          if (navigator.canPop()) {
            navigator.pop();
          }
        } catch (error) {
          if (navigator.canPop()) {
            navigator.pop();
          }
          showSnackbar(
            title: "Lỗi hệ thống",
            message: "$error.",
            type: "error",
          );
        }
      },
      child: ListView(
        padding: const EdgeInsets.only(bottom: spacingMedium),
        children: [
          Text(
            "Thông tin đặt vé phim",
            style: TextStyle(
              color: colorTextApp,
              letterSpacing: letterSpacingSmall,
              fontWeight: fontWeightMedium,
              fontSize: textfontSizeApp,
            ),
          ),
          const SizedBox(height: spacingMedium),
          Text(
            "Rạp : ${widget.paramsPayPage.cinema.name}",
            style: TextStyle(
              color: colorTextApp,
              letterSpacing: letterSpacingSmall,
              fontWeight: fontWeightNormal,
              fontSize: textfontSizeNote,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: spacingMedium),

          Text(
            "Địa chỉ : ${widget.paramsPayPage.cinema.address}",
            style: TextStyle(
              color: colorTextApp,
              letterSpacing: letterSpacingSmall,
              fontWeight: fontWeightNormal,
              fontSize: textfontSizeNote,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),

          if (widget.paramsPayPage.totalChooseFoodDrink.isNotEmpty)
            Column(
              spacing: spacingMedium,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: spacingMedium),
                Text(
                  "Bắp nước",
                  style: TextStyle(
                    color: colorTextApp,
                    letterSpacing: letterSpacingSmall,
                    fontWeight: fontWeightMedium,
                    fontSize: textfontSizeApp,
                  ),
                ),
                Column(
                  spacing: spacingMedium,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.paramsPayPage.totalChooseFoodDrink.length,
                    (index) => Column(
                      spacing: spacingMedium,
                      children: [
                        Text(
                          "${index + 1} : ${widget.paramsPayPage.totalChooseFoodDrink[index]["id"].name} (${widget.paramsPayPage.totalChooseFoodDrink[index]["id"].description}) - ${widget.paramsPayPage.totalChooseFoodDrink[index]["id"].price} VND x ${widget.paramsPayPage.totalChooseFoodDrink[index]["quantity"]}",
                          style: TextStyle(
                            color: colorTextApp,
                            letterSpacing: letterSpacingSmall,
                            fontWeight: fontWeightNormal,
                            fontSize: textfontSizeNote,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: spacingMedium),

          Text(
            "Giá vé : ${widget.paramsPayPage.movie.price} VND x ${widget.paramsPayPage.selectedSeats.length}",
            style: TextStyle(
              color: colorTextApp,
              letterSpacing: letterSpacingSmall,
              fontWeight: fontWeightMedium,
              fontSize: textfontSizeApp,
            ),
          ),
          const SizedBox(height: spacingMedium),

          Text(
            "Tổng cộng : ${selectedPaymentMethod == "Paypal" ? price : widget.paramsPayPage.price}",
            style: TextStyle(
              color: colorTextApp,
              letterSpacing: letterSpacingSmall,
              fontWeight: fontWeightMedium,
              fontSize: textfontSizeApp,
            ),
          ),
          const SizedBox(height: spacingMedium),

          if (widget.paramsPayPage.typeInformationThisPage != "review")
            Text(
              "Các phương thức thanh toán",
              style: TextStyle(
                color: colorTextApp,
                letterSpacing: letterSpacingSmall,
                fontWeight: fontWeightMedium,
                fontSize: textfontSizeApp,
              ),
            ),
          const SizedBox(height: spacingMedium),

          if (widget.paramsPayPage.typeInformationThisPage != "review")
            paymentMethods.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      paymentMethods.length,
                      (index) => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final navigator = Navigator.of(context);
                                selectedPaymentMethod =
                                    paymentMethods[index].paymentMethod;
                                if (selectedPaymentMethod == "Paypal") {
                                  try {
                                    Get.dialog(
                                      Center(child: circularProgress),
                                      barrierDismissible: false,
                                    );
                                    final result = await getExchangeRate();
                                    if (navigator.canPop()) {
                                      navigator.pop();
                                    }
                                    if (!result["success"] ||
                                        result["usd"] == null) {
                                      showSnackbar(
                                        title: "USD",
                                        message: result["message"],
                                        type: "error",
                                      );
                                    }

                                    setState(() {
                                      price =
                                          "${double.tryParse((currencyVND(widget.paramsPayPage.price) * result["usd"]).toStringAsFixed(2))} USD";
                                    });
                                  } catch (e) {
                                    if (navigator.canPop()) {
                                      navigator.pop();
                                    }
                                    showSnackbar(
                                      title: "Lỗi hệ thống",
                                      message: "$e",
                                      type: "error",
                                    );
                                  }
                                } else {
                                  setState(() {
                                    selectedPaymentMethod =
                                        paymentMethods[index].paymentMethod;
                                  });
                                }
                              },
                              child: Text(
                                " ${paymentMethods[index].paymentMethod}",
                                style: TextStyle(
                                  color: colorTextApp,
                                  letterSpacing: letterSpacingSmall,
                                  fontWeight: fontWeightNormal,
                                  fontSize: textfontSizeNote,
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                          Radio<String>(
                            fillColor: WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return colorIcon;
                              }
                              return Colors.grey;
                            }),
                            value: paymentMethods[index].paymentMethod!,
                            groupValue: selectedPaymentMethod,
                            onChanged: (value) => setState(() {
                              selectedPaymentMethod = value;
                            }),
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(
                    "Hiện không có phương thức thanh toán nào được hỗ trợ.",
                    style: TextStyle(
                      color: colorTextWarning,
                      letterSpacing: letterSpacingSmall,
                      fontWeight: fontWeightNormal,
                      fontSize: textfontSizeApp,
                    ),
                    textAlign: TextAlign.center,
                  ),
          const SizedBox(height: spacingBig),

          if (widget.paramsPayPage.typeInformationThisPage != "review")
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  if (seatUser == null) {
                    showSnackbar(
                      title: "Ghế",
                      message:
                          "Bạn đã hết thời gian giữ ghế. Vui lòng chọn lại ghế.",
                      type: "error",
                    );
                    NavigationHelper.goBack();
                  } else {
                    try {
                      if (selectedPaymentMethod == "" ||
                          selectedPaymentMethod == null) {
                        return;
                      }
                      Get.dialog(
                        Center(child: circularProgress),
                        barrierDismissible: false,
                      );

                      final foodDrinks = widget
                          .paramsPayPage
                          .totalChooseFoodDrink
                          .map(
                            (fd) => {
                              "id": fd["id"].idFoodDrink,
                              "quantity": fd["quantity"],
                            },
                          )
                          .toList();

                      Object data = {
                        "idMovieRoom":
                            widget.paramsPayPage.movieRoom.idMovieRoom,
                        "foodDrinks": foodDrinks,
                        "time": widget.paramsPayPage.selectedTime,
                        "price": selectedPaymentMethod == "Paypal"
                            ? price
                            : widget.paramsPayPage.price,
                        "paymentMethod": selectedPaymentMethod,
                        "selectedSeats": widget.paramsPayPage.selectedSeats,
                        "expiredAt": widget.paramsPayPage.seatUser?.expiredAt,
                      };

                      final order = await ref
                          .read(orderServiceProvider)
                          .createOrder(data);

                      if (navigator.canPop()) {
                        navigator.pop();
                      }

                      if (!order["success"]) {
                        showSnackbar(
                          title: "Đặt vé",
                          message: order["message"],
                          type: "error",
                        );
                        return;
                      }

                      await ref
                          .read(getOrderWithTicketIdUser.notifier)
                          .loadTicket();

                      switch (selectedPaymentMethod) {
                        case "Paypal":
                          Get.dialog(
                            Center(child: circularProgress),
                            barrierDismissible: false,
                          );
                          final resOrder = order["data"]["order"]["_id"];
                          final priceOrder = order["data"]["order"]["price"];

                          final Object data = {
                            "amount": priceOrder,
                            "orderId": resOrder,
                          };
                          final res = await ref
                              .read(paypalServiceProvider)
                              .payPaypal(data);

                          if (navigator.canPop()) {
                            navigator.pop();
                          }

                          if (!res["success"]) {
                            showSnackbar(
                              title: "Paypal",
                              message: res["message"],
                              type: "error",
                            );
                            return;
                          }

                          String url = res["data"]["url"];
                          if (!url.contains('?')) {
                            url +=
                                '?disable-funding=paylater&disable-funding=credit';
                          } else {
                            url +=
                                '&disable-funding=paylater&disable-funding=credit';
                          }

                          final result =
                              await NavigationHelper.goToWebViewPaypal(
                                approvalUrl: url,
                              );

                          if (result != null && result['status'] == 'success') {
                            Get.dialog(
                              Center(child: circularProgress),
                              barrierDismissible: false,
                            );

                            final orderId = result['orderId'];
                            final token = result['token'];

                            await ref
                                .read(paypalServiceProvider)
                                .paySuccess(orderId, token);

                            Object data = {
                              "idOrder": orderId,
                              "paymentStatus": "Đã thanh toán",
                            };

                            final resultUpdateTransaction = await ref
                                .read(orderServiceProvider)
                                .updateTransaction(data);

                            if (navigator.canPop()) {
                              navigator.pop();
                            }

                            if (!resultUpdateTransaction["success"]) {
                              showSnackbar(
                                title: "Thanh toán",
                                message: resultUpdateTransaction["message"],
                                type: "error",
                              );
                              return;
                            }

                            await ref
                                .read(getOrderWithTicketIdUser.notifier)
                                .loadTicket();

                            showSnackbar(
                              title: "Thanh toán",
                              message: resultUpdateTransaction["message"],
                              type: "success",
                            );
                            NavigationHelper.goToHomeAndRemove(index: 2);
                          } else if (result?["status"] == "cancel") {
                          } else if (result?["status"] == "fail") {
                            showSnackbar(
                              title: "Lỗi hệ thống",
                              message: "${result?["error"]}",
                              type: "error",
                            );
                          }

                          break;
                        case "MoMo":
                          final idOrder = order["data"]["order"]["_id"];
                          final priceOrder = order["data"]["order"]["price"];
                          var payUrl = order["data"]["order"]["payUrl"];

                          if (payUrl == "") {
                            Get.dialog(
                              Center(child: circularProgress),
                              barrierDismissible: false,
                            );
                            final Object data = {
                              "amount": priceOrder,
                              "orderId": idOrder,
                            };
                            final res = await ref
                                .read(momoServiceProvider)
                                .payMoMo(data);

                            if (navigator.canPop()) {
                              navigator.pop();
                            }

                            if (!res["success"]) {
                              showSnackbar(
                                title: "MoMo",
                                message: res["message"],
                                type: "error",
                              );
                              return;
                            }

                            Get.dialog(
                              Center(child: circularProgress),
                              barrierDismissible: false,
                            );

                            final Object dataUpdatePayUrl = {
                              "idOrder": idOrder,
                              "payUrl": res["data"]["payUrl"],
                            };

                            final resUpdateUrlOrder = await ref
                                .read(orderServiceProvider)
                                .updatePayUrl(dataUpdatePayUrl);

                            if (navigator.canPop()) {
                              navigator.pop();
                            }

                            if (!resUpdateUrlOrder["success"]) {
                              showSnackbar(
                                title: "MoMo",
                                message: resUpdateUrlOrder["message"],
                                type: "error",
                              );
                              return;
                            }

                            payUrl = res["data"]["payUrl"];
                          }

                          final result = await NavigationHelper.goToWebViewMoMo(
                            approvalUrl: payUrl,
                          );

                          if (result != null && result['status'] == 'success') {
                            Get.dialog(
                              Center(child: circularProgress),
                              barrierDismissible: false,
                            );

                            final orderId = result['orderId'];

                            await ref
                                .read(momoServiceProvider)
                                .transactionMoMo(orderId);

                            Object data = {
                              "idOrder": orderId,
                              "paymentStatus": "Đã thanh toán",
                            };

                            final resultUpdateTransaction = await ref
                                .read(orderServiceProvider)
                                .updateTransaction(data);

                            if (navigator.canPop()) {
                              navigator.pop();
                            }

                            if (!resultUpdateTransaction["success"]) {
                              showSnackbar(
                                title: "Thanh toán",
                                message: resultUpdateTransaction["message"],
                                type: "error",
                              );
                              return;
                            }

                            await ref
                                .read(getOrderWithTicketIdUser.notifier)
                                .loadTicket();

                            showSnackbar(
                              title: "Thanh toán",
                              message: resultUpdateTransaction["message"],
                              type: "success",
                            );
                            NavigationHelper.goToHomeAndRemove(index: 2);
                          } else if (result?["status"] == "cancel") {
                          } else if (result?["status"] == "fail") {
                            showSnackbar(
                              title: "Lỗi hệ thống",
                              message: "${result?["error"]}",
                              type: "error",
                            );
                          }

                          break;
                      }
                    } catch (error) {
                      if (navigator.canPop()) {
                        navigator.pop();
                      }
                      showSnackbar(
                        title: "Lỗi hệ thống",
                        message: "$error",
                        type: "error",
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedPaymentMethod != null
                      ? colorButton
                      : hexColorPlaceHolder,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadiusButton,
                  ),
                ),

                child: Text("Thanh toán", style: textStyleElevatedButton),
              ),
            ),
        ],
      ),
    );
  }
}
