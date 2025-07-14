import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/convert_time.dart';
import 'package:ceni_fruit/config/catch_network_image.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/curvedclipper.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/room.dart';
import 'package:ceni_fruit/model/holding_seat.dart';
import 'package:ceni_fruit/pages/order_food_drink.dart';
import 'package:ceni_fruit/provider/holding_seat_provider.dart';
import 'package:ceni_fruit/provider/order_provider.dart';
import 'package:ceni_fruit/service/currency_exchange_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:slide_countdown/slide_countdown.dart';

class BookingPage extends ConsumerStatefulWidget {
  final Movie movie;
  final MovieRoom movieRoom;
  final Cinema cinema;
  final Room room;
  final HoldingSeat? seatUser;
  final List<String> seatsDiff;
  final List<String> booked;

  const BookingPage({
    super.key,
    required this.movie,
    required this.movieRoom,
    required this.cinema,
    required this.room,
    required this.seatUser,
    required this.seatsDiff,
    required this.booked,
  });

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  late HoldingSeat? seatUser;
  List<String> seatsDiff = [];
  List<String> booked = [];

  List<String> selectedSeats = [];

  String? selectedTime;
  String price = "";

  @override
  void initState() {
    super.initState();
    if (widget.movieRoom.times != null && widget.movieRoom.times!.isNotEmpty) {
      selectedTime = widget.movieRoom.times!.first;
    }

    seatUser = widget.seatUser;
    selectedSeats = seatUser?.selectedSeat ?? [];
    seatsDiff = widget.seatsDiff;
    booked = widget.booked;
    price = formatCurrencyVND(
      currencyVND(widget.movie.price!) * selectedSeats.length,
    );
  }

  List<String> stateSeat = ["selecting", "booked", "empty", "holdingDiff"];

  List<String> alphabet = List.generate(
    26,
    (index) => String.fromCharCode(65 + index),
  );

  String getSeatCode(int row, int col) {
    String rowLetter = String.fromCharCode(65 + row);
    return '$rowLetter${col + 1}';
  }

  AppBar appBar() {
    final time = convertTime(seatUser?.expiredAt ?? "");
    return AppBar(
      title: Text("${widget.cinema.name}", style: tilteStyleApp),
      backgroundColor: Colors.transparent,
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
                      onDone: () async {
                        try {
                          Get.dialog(
                            Center(child: circularProgress),
                            barrierDismissible: false,
                          );
                          final data = await ref
                              .read(holdingSeatServiceProvider)
                              .getSelectedSeat(widget.movieRoom.idMovieRoom!);

                          if (Get.isDialogOpen == true) {
                            Get.back();
                          }

                          if (!data["success"]) {
                            showSnackbar(
                              title: "Hoàn tác Ghế",
                              message: data["message"],
                              type: "error",
                            );
                            return;
                          }

                          setState(() {
                            seatUser = null;
                            selectedSeats = [];
                            seatsDiff = [];

                            price = formatCurrencyVND(
                              currencyVND(widget.movie.price!) *
                                  selectedSeats.length,
                            );
                          });
                        } catch (error) {
                          if (Get.isDialogOpen == true) {
                            Get.back();
                          }
                          showSnackbar(
                            title: "Ghế",
                            message: "$error",
                            type: "error",
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(),
      body: Stack(
        children: [
          ...backgroundApp(widget.movie.urlImage!),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildNameMovieAndDropDown(),
                  buildScreen(),
                  const SizedBox(height: spacingMedium),
                  SizedBox(height: 300, child: buildSingleSeat()),
                  const SizedBox(height: spacingBig),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildLegend(),
                          const SizedBox(height: spacingMedium),
                          if (currencyVND(price) > 0) buildShowSelectingSeat(),
                          buildPrice(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShowSelectingSeat() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Đang chọn ghế: ",
          style: TextStyle(
            color: colorTextApp,
            fontWeight: fontWeightMedium,
            fontSize: textfontSizeApp,
            letterSpacing: letterSpacingSmall,
          ),
        ),
        Expanded(
          child: Wrap(
            children: selectedSeats.map((seat) {
              String seatText =
                  seat.toString() +
                  (selectedSeats.length > 1 && selectedSeats.last != seat
                      ? ", "
                      : "");
              return Text(
                seatText,
                style: const TextStyle(
                  fontSize: textfontSizeApp,
                  fontWeight: fontWeightMedium,
                  color: colorTextApp,
                  letterSpacing: letterSpacingSmall,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildNameMovieAndDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${widget.movie.name}",
          style: const TextStyle(
            fontSize: textfontSizeTitleAppBar,
            fontWeight: fontWeightSemiBold,
            color: colorTextApp,
            letterSpacing: letterSpacingSmall,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadiusButton,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                alignment: Alignment.center,
                value: selectedTime,
                hint: const Text(
                  "Chọn",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: textfontSizeApp,
                    fontWeight: fontWeightMedium,
                    letterSpacing: letterSpacingSmall,
                  ),
                  textAlign: TextAlign.center,
                ),

                dropdownStyleData: const DropdownStyleData(
                  offset: Offset(0, -15),
                  decoration: BoxDecoration(
                    color: colorTextApp,
                    borderRadius: borderRadiusButton,
                  ),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: iconfontSizeNormal,
                    color: Colors.black,
                  ),
                ),

                items: (widget.movieRoom.times ?? []).map((time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(
                      time,
                      style: const TextStyle(
                        fontSize: textfontSizeApp,
                        fontWeight: fontWeightMedium,
                        letterSpacing: letterSpacingSmall,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTime = value;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSingleSeat() {
    int rowCount = widget.room.rowQuantity!;
    int columnCount = widget.room.colQuantity!;
    double sizeSeat = 25;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        spacing: spacingSmall,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 33),
            child: Column(
              spacing: spacingMedium,
              children: List.generate(
                rowCount,
                (index) => SizedBox(
                  width: sizeSeat,
                  height: sizeSeat,
                  child: Center(
                    child: Text(
                      alphabet[index],
                      style: const TextStyle(
                        color: colorTextApp,
                        fontSize: textfontSizeNote,
                        fontWeight: fontWeightMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                spacing: spacingSmall,
                children: [
                  Row(
                    spacing: spacingSmall,
                    children: List.generate(
                      columnCount,
                      (index) => SizedBox(
                        width: sizeSeat,
                        height: sizeSeat,
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(
                              color: colorTextApp,
                              fontSize: textfontSizeNote,
                              fontWeight: fontWeightMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    spacing: spacingMedium,
                    children: List.generate(rowCount, (row) {
                      return Row(
                        spacing: spacingSmall,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(columnCount, (col) {
                          final seatCode = getSeatCode(row, col);
                          bool isSelected = selectedSeats.contains(seatCode);
                          bool checkBookedSeat = booked.contains(seatCode);
                          bool checkSeatsDiff = seatsDiff.contains(seatCode);
                          return GestureDetector(
                            onTap: () async {
                              try {
                                if (checkBookedSeat || checkSeatsDiff) {
                                  return;
                                }

                                Get.dialog(
                                  Center(child: circularProgress),
                                  barrierDismissible: false,
                                );

                                final data = await ref
                                    .read(holdingSeatServiceProvider)
                                    .chooseSeat(
                                      idMovieRoom:
                                          widget.movieRoom.idMovieRoom!,
                                      seat: seatCode,
                                    );
                                final dataa = await ref
                                    .read(holdingSeatServiceProvider)
                                    .getSelectedSeat(
                                      widget.movieRoom.idMovieRoom!,
                                    );

                                final dataBooked = await ref
                                    .read(orderServiceProvider)
                                    .getBooked(
                                      widget.room.idRoom!,
                                      widget.movie.idMovie!,
                                    );

                                await ref
                                    .read(holdingSeatNofierProvider.notifier)
                                    .getHoldingSeatUser();

                                if (Get.isDialogOpen == true) {
                                  Get.back();
                                }

                                if (data["data"]["type"] == "deleted") {
                                  setState(() {
                                    seatUser = null;
                                    selectedSeats = [];
                                    seatsDiff = [];
                                    price = formatCurrencyVND(
                                      currencyVND(widget.movie.price!) *
                                          selectedSeats.length,
                                    );
                                  });
                                  await ref
                                      .read(getOrderWithTicketIdUser.notifier)
                                      .loadTicket();
                                  return;
                                }

                                if (!data["success"]) {
                                  showSnackbar(
                                    title: "Ghế",
                                    message: data["message"],
                                    type: "error",
                                  );
                                  return;
                                }

                                if (!dataBooked["success"]) {
                                  showSnackbar(
                                    title: "Ghế",
                                    message: dataBooked["message"],
                                    type: "error",
                                  );
                                  return;
                                }

                                setState(() {
                                  seatUser = HoldingSeat.fromJson(
                                    dataa["data"]["seatUser"],
                                  );
                                  selectedSeats = seatUser?.selectedSeat ?? [];
                                  seatsDiff =
                                      (dataa["data"]["seatsDiff"] as List)
                                          .map((s) => s.toString())
                                          .toList();
                                  booked =
                                      (dataBooked["data"]["booked"] as List)
                                          .map((s) => s.toString())
                                          .toList();
                                  price = formatCurrencyVND(
                                    currencyVND(widget.movie.price!) *
                                        selectedSeats.length,
                                  );
                                });
                              } catch (error) {
                                if (Get.isDialogOpen == true) {
                                  Get.back();
                                }
                                showSnackbar(
                                  title: "Ghế",
                                  message: "$error",
                                  type: "error",
                                );
                              }
                            },
                            child: Container(
                              width: sizeSeat,
                              height: sizeSeat,
                              decoration: BoxDecoration(
                                color: checkBookedSeat || checkSeatsDiff
                                    ? Colors.black87
                                    : Colors.white,
                                borderRadius: borderRadiusButtonSmall,
                                border: isSelected
                                    ? null
                                    : checkBookedSeat
                                    ? Border.all(
                                        color: hexColorLogout,
                                        width: 3,
                                      )
                                    : checkSeatsDiff
                                    ? Border.all(color: colorIcon, width: 3)
                                    : Border.all(
                                        color: Colors.blue.shade700,
                                        width: 2,
                                      ),
                              ),
                              child: isSelected
                                  ? ClipRRect(
                                      borderRadius: borderRadiusButtonSmall,
                                      child: cachedNetworkImageConfig(
                                        widget.movie.urlImage!,
                                        sizeSeat,
                                        sizeSeat,
                                        BoxFit.fill,
                                        iconfontSizeTiny,
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScreen() {
    return CustomPaint(
      painter: CurvedShadowPainter(),
      size: const Size(double.infinity, 80),
    );
  }

  Widget buildLegend() {
    return Column(
      spacing: spacingMedium,
      children: [
        Row(
          spacing: spacingBig,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            legendItem(Colors.white, 'Ghế đơn', stateSeat[2]),
            legendItem(Colors.black87, 'Ng.đang giữ', stateSeat[3]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: spacingBig,
          children: [
            legendItem(Colors.orange, 'Đang chọn', stateSeat[0]),
            legendItem(Colors.black87, 'Đã bán', stateSeat[1]),
          ],
        ),
      ],
    );
  }

  Widget legendItem(Color color, String label, String state) {
    final setBorder = stateSeat[2] == state
        ? Border.all(color: Colors.blue.shade700, width: 2)
        : stateSeat[1] == state
        ? Border.all(color: hexColorLogout, width: 3)
        : stateSeat[3] == state
        ? Border.all(color: colorIcon, width: 3)
        : null;
    return Row(
      spacing: spacingMedium,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadiusButtonSmall,
            border: setBorder,
          ),
          child: stateSeat[0] == state
              ? ClipRRect(
                  borderRadius: borderRadiusButtonSmall,
                  child: cachedNetworkImageConfig(
                    widget.movie.urlImage!,
                    28,
                    28,
                    BoxFit.fill,
                    iconfontSizeTiny,
                  ),
                )
              : null,
        ),
        Text(
          label,
          style: const TextStyle(
            color: colorTextApp,
            fontSize: textfontSizeApp,
            letterSpacing: letterSpacingSmall,
            fontWeight: fontWeightNormal,
          ),
        ),
      ],
    );
  }

  Widget buildPrice() {
    final bool selectedState = currencyVND(price) > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            if (selectedState)
              Text(
                price,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: textfontSizeTitleAppBar,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            if (currencyVND(price) > 0 && selectedSeats.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderFoodDrink(
                    movie: widget.movie,
                    selectedSeats: selectedSeats,
                    price: price,
                    cinema: widget.cinema,
                    room: widget.room,
                    movieRoom: widget.movieRoom,
                    time: selectedTime ?? "",
                    seatUser: seatUser,
                  ),
                ),
              );
            }
            return;
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedState ? colorButton : hexColorPlaceHolder,
            shape: RoundedRectangleBorder(borderRadius: borderRadiusButton),
          ),
          child: Text('Tiếp tục', style: textStyleElevatedButton),
        ),
      ],
    );
  }
}
