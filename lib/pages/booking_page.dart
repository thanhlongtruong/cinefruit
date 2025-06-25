import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/curvedclipper.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/order.dart';
import 'package:ceni_fruit/model/room.dart';
import 'package:ceni_fruit/provider/order.dart';
import 'package:ceni_fruit/provider/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class BookingPage extends ConsumerStatefulWidget {
  final Movie movie;
  final MovieRoom movieRoom;
  final Cinema cinema;
  final Room room;

  const BookingPage({
    super.key,
    required this.movie,
    required this.movieRoom,
    required this.cinema,
    required this.room,
  });

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  String? selectedTime;
  @override
  void initState() {
    super.initState();
    if (widget.movieRoom.time != null && widget.movieRoom.time!.isNotEmpty) {
      selectedTime = widget.movieRoom.time!.first;
    }
  }

  List<String> selectedSeats = [];

  List<String> stateSeat = ["selecting", "booked", "empty"];

  List<String> alphabet = List.generate(
    26,
    (index) => String.fromCharCode(65 + index),
  );

  String getSeatCode(int row, int col) {
    String rowLetter = String.fromCharCode(65 + row);
    return '$rowLetter${col + 1}';
  }

  double price = 0;

  List<String> selected = [
    "A1",
    "B1",
    "C1",
    "D1",
    "A2",
    "C2",
    "A4",
    "B4",
    "C4",
    "D4",
    "D5",
    "D6",
    "A6",
    "B6",
    "C6",
  ];

  AppBar appBar() {
    return AppBar(
      title: Text(
        "${widget.cinema.name}",
        style: const TextStyle(
          color: colorTextApp,
          fontSize: textfontSizeTitleAppBar,
          letterSpacing: letterSpacingSmall,
          fontWeight: fontWeightTitleAppBar,
          shadows: [
            Shadow(color: Colors.purple, blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: colorTextApp),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderNotifier = ref.watch(orderProvider(widget.movieRoom));
    if (orderNotifier.isLoading) {
      buildLoadingScreen();
    }
    if (orderNotifier.hasError) {
      buildErrorScreen(orderNotifier.error);
    }
    final orders = orderNotifier.value;
    // final ticketNotifier = ref.watch(ticketProvider(widget.movieRoom));
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
                  const SizedBox(height: 15),
                  SizedBox(height: 300, child: buildSingleSeat()),
                  const SizedBox(height: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildLegend(),
                          const SizedBox(height: 30),
                          if (price > 0) buildShowSelectingSeat(),
                          const SizedBox(height: 20),
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
            fontSize: textfontSizeNote,
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
                style: TextStyle(
                  fontSize: textfontSizeNote,
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
          style: TextStyle(
            fontSize: textfontSizeTitleAppBar,
            fontWeight: fontWeightSemiBold,
            color: colorTextApp,
            letterSpacing: letterSpacingSmall,
          ),
        ),
        IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
                    size: iconfontSizeApp,
                    color: Colors.black,
                  ),
                ),

                items: (widget.movieRoom.time ?? []).map((time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(
                      time,
                      style: TextStyle(
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
                      style: TextStyle(
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
                            style: TextStyle(
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
                          bool checkBookedSeat = selected.contains(seatCode);
                          return GestureDetector(
                            onTap: () {
                              if (checkBookedSeat) {
                                return;
                              }
                              setState(() {
                                if (selectedSeats.contains(seatCode)) {
                                  selectedSeats.remove(seatCode);
                                } else {
                                  selectedSeats.add(seatCode);
                                }
                                price = double.parse(
                                  ((widget.movie.price ?? 0) *
                                          selectedSeats.length)
                                      .toStringAsFixed(2),
                                );
                              });
                            },
                            child: Container(
                              width: sizeSeat,
                              height: sizeSeat,
                              decoration: BoxDecoration(
                                color: checkBookedSeat
                                    ? Colors.black87
                                    : Colors.white,
                                borderRadius: borderRadiusButtonSmall,
                                border: isSelected
                                    ? null
                                    : checkBookedSeat
                                    ? Border.all(color: Colors.red, width: 3)
                                    : Border.all(
                                        color: Colors.blue.shade700,
                                        width: 2,
                                      ),
                              ),
                              child: isSelected
                                  ? ClipRRect(
                                      borderRadius: borderRadiusButtonSmall,
                                      child: CachedNetworkImage(
                                        height: sizeSeat,
                                        width: sizeSeat,
                                        fit: BoxFit.fill,
                                        imageUrl: widget.movie.urlImage!,
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
        legendItem(Colors.white, 'Ghế đơn', stateSeat[2]),
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
        ? Border.all(color: Colors.red, width: 3)
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
                  child: CachedNetworkImage(
                    imageUrl: widget.movie.urlImage!,
                    height: 28,
                    width: 28,
                    fit: BoxFit.fill,
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
    final bool selectedState = price > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            if (selectedState)
              Text(
                "$price VND",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedState ? Colors.orange : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Tiếp tục',
            style: TextStyle(
              color: colorTextApp,
              fontWeight: fontWeightMedium,
              fontSize: textfontSizeApp,
              letterSpacing: letterSpacingSmall,
            ),
          ),
        ),
      ],
    );
  }
}
