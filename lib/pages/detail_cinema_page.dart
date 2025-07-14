import 'package:ceni_fruit/config/day_of_cinema.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/style_button.dart';
import 'package:ceni_fruit/home_creen.dart';
import 'package:ceni_fruit/pages/login_page.dart';
import 'package:ceni_fruit/provider/holding_seat_provider.dart';
import 'package:ceni_fruit/provider/movie_provider.dart';
import 'package:ceni_fruit/provider/order_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/pages/booking_page.dart';
import 'package:ceni_fruit/provider/cinema_provider.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:intl/intl.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/catch_network_image.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/room.dart';
import 'package:ceni_fruit/model/holding_seat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailCinemaPage extends ConsumerStatefulWidget {
  final List<DetailCinemaState> detailCinemaState;
  final Cinema cinema;

  const DetailCinemaPage({
    super.key,
    required this.detailCinemaState,
    required this.cinema,
  });

  @override
  ConsumerState<DetailCinemaPage> createState() => _DetailCinemaPageState();
}

class _DetailCinemaPageState extends ConsumerState<DetailCinemaPage> {
  int selectedDate = 0;
  DateTime date = DateUtils.dateOnly(
    DateTime.now().add(const Duration(days: 1)),
  );

  late List<DetailCinemaState> detailCinemaState;

  late DetailCinemaParams params;
  double score = 0;
  @override
  void initState() {
    super.initState();

    detailCinemaState = widget.detailCinemaState;

    params = DetailCinemaParams(
      cinemaId: widget.cinema.idCinema!,
      date: DateFormat("dd/MM/yyyy").format(date),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getMovieDate() async {
    Get.dialog(Center(child: circularProgress), barrierDismissible: false);

    await ref.read(detailCinemaProvider(params).notifier).loadDetailCinema();
    final state = ref.read(detailCinemaProvider(params));

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    if (state.hasError) {
      showSnackbar(
        title: "Lỗi hệ thống",
        message: "${state.error}",
        type: "error",
      );
    } else {
      final value = state.value;
      setState(() {
        detailCinemaState = value ?? [];
      });
    }
  }

  Widget buildItem(DetailCinemaState detailCinemaState, List<Room> rooms) {
    const style = TextStyle(
      fontWeight: fontWeightNormal,
      color: colorTextApp,
      letterSpacing: letterSpacingSmall,
      fontSize: textfontSizeNote,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(spacingMedium),
          child: Column(
            spacing: spacingMedium,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: spacingMedium,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: borderRadiusCardSmall,
                    child: cachedNetworkImageConfig(
                      detailCinemaState.movie.urlImage!,
                      77,
                      115,
                      BoxFit.contain,
                      iconfontSizeNormal,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: spacingSmall,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${detailCinemaState.movie.name}",
                            style: const TextStyle(
                              fontWeight: fontWeightMedium,
                              color: colorTextApp,
                              letterSpacing: letterSpacingSmall,
                              fontSize: textfontSizeApp,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: spacingSmall,
                                children: [
                                  IntrinsicWidth(
                                    child: const Icon(
                                      Icons.history_outlined,
                                      color: colorIcon,
                                      size: iconfontSizeNormal,
                                    ),
                                  ),
                                  IntrinsicWidth(
                                    child: Text(
                                      '${detailCinemaState.movie.duration}',
                                      style: style,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: spacingBig),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: spacingSmall,
                                children: [
                                  const Icon(
                                    Icons.calendar_month_rounded,
                                    color: colorIcon,
                                    size: iconfontSizeNormal,
                                  ),
                                  Text(
                                    "${detailCinemaState.movie.releaseDate}",
                                    style: style,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: spacingBig,
                            children: [
                              Row(
                                spacing: spacingSmall,
                                children: [
                                  const Icon(
                                    Icons.star_rate_rounded,
                                    color: colorIcon,
                                    size: iconfontSizeNormal,
                                  ),
                                  Text(
                                    '${detailCinemaState.movie.rate} /10',
                                    style: style,
                                  ),
                                  if (detailCinemaState.movie.rateCount! > 0)
                                    Text(
                                      "(${detailCinemaState.movie.rateCount})",
                                      style: style,
                                    ),
                                ],
                              ),

                              GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,

                                          insetPadding: EdgeInsets.all(
                                            spacingMedium,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: borderRadiusCardSmall,
                                          ),

                                          title: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontWeight: fontWeightSemiBold,
                                                color: hexColorTextBlack,
                                                letterSpacing:
                                                    letterSpacingSmall,
                                                fontSize:
                                                    textfontSizeTitleAppBar,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${detailCinemaState.movie.name} ",
                                                ),
                                                TextSpan(
                                                  text: "($score/10)",
                                                  style: styleTextSpecial,
                                                ),
                                              ],
                                            ),
                                          ),
                                          titlePadding: const EdgeInsets.all(
                                            spacingMedium,
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                            right: spacingMedium,
                                            left: spacingMedium,
                                            bottom: spacingMedium,
                                          ),
                                          buttonPadding: const EdgeInsets.all(
                                            spacingMedium,
                                          ),
                                          content: RatingBar.builder(
                                            minRating: 0,
                                            maxRating: 10,
                                            itemCount: 10,
                                            allowHalfRating: true,
                                            wrapAlignment: WrapAlignment.center,
                                            itemSize: 30,
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                                  Icons.star_rounded,
                                                  color: colorIcon,
                                                ),
                                            onRatingUpdate: (value) {
                                              setState(() {
                                                score = value;
                                              });
                                            },
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () => Get.back(),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                      hexColorLogout,
                                                    ),
                                                shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        borderRadiusButton,
                                                  ),
                                                ),
                                              ),
                                              child: Text("HỦY", style: style),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  Get.back();
                                                  final navigator =
                                                      Navigator.of(context);

                                                  Get.dialog(
                                                    Center(
                                                      child: circularProgress,
                                                    ),
                                                    barrierDismissible: false,
                                                  );

                                                  final movieRoom =
                                                      detailCinemaState
                                                          .movieRooms
                                                          .firstWhere(
                                                            (mr) =>
                                                                mr.idMovie ==
                                                                detailCinemaState
                                                                    .movie
                                                                    .idMovie,
                                                          );
                                                  final resultRatingMovie =
                                                      await ref
                                                          .read(
                                                            movieServiceProvider,
                                                          )
                                                          .ratingMovie(
                                                            movieRoom
                                                                .idMovieRoom!,
                                                            score,
                                                          );

                                                  if (Get.isDialogOpen ==
                                                      true) {
                                                    Get.back();
                                                  }

                                                  if (!resultRatingMovie["success"]) {
                                                    showSnackbar(
                                                      title: "Đánh giá phim",
                                                      message:
                                                          resultRatingMovie["message"],
                                                      type: "error",
                                                      func: () async {
                                                        if (resultRatingMovie
                                                                .containsKey(
                                                                  "typeError",
                                                                ) &&
                                                            resultRatingMovie["typeError"] ==
                                                                "Chưa được xác minh") {
                                                          navigator.push(
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  LoginPage(),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    );
                                                    return;
                                                  }
                                                  await getMovieDate();
                                                  showSnackbar(
                                                    title: "Đánh giá phim",
                                                    message:
                                                        resultRatingMovie["message"],
                                                    type: "success",
                                                  );
                                                } catch (error) {
                                                  if (Get.isDialogOpen ==
                                                      true) {
                                                    Get.back();
                                                  }

                                                  showSnackbar(
                                                    title: "Lỗi hệ thống",
                                                    message: "$error",
                                                    type: "error",
                                                  );
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                      colorTextSuccess,
                                                    ),
                                                shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        borderRadiusButton,
                                                  ),
                                                ),
                                              ),

                                              child: Text(
                                                "XÁC NHẬN",
                                                style: style,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ).then((value) {
                                    setState(() {
                                      score = 0;
                                    });
                                  });
                                },
                                child: Text(
                                  'Đánh giá',
                                  style: styleTextSpecial,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: spacingMedium,
                children: rooms.map((r) {
                  return customElevatedButtonBgTransparent(() async {
                    try {
                      Get.dialog(
                        Center(child: circularProgress),
                        barrierDismissible: false,
                      );
                      final navigator = Navigator.of(context);

                      final movieRoom = detailCinemaState.movieRooms.firstWhere(
                        (mr) => mr.idRoom == r.idRoom,
                      );

                      final data = await ref
                          .read(holdingSeatServiceProvider)
                          .getSelectedSeat(movieRoom.idMovieRoom!);

                      final dataBooked = await ref
                          .read(orderServiceProvider)
                          .getBooked(
                            r.idRoom!,
                            detailCinemaState.movie.idMovie!,
                          );

                      if (Get.isDialogOpen == true) {
                        Get.back();
                      }

                      if (!data["success"]) {
                        showSnackbar(
                          title: "Tài khoản",
                          message: data["message"],
                          type: "error",
                          func: () async {
                            if (data.containsKey("typeError") &&
                                data["typeError"] == "Chưa được xác minh") {
                              navigator.push(
                                MaterialPageRoute(builder: (_) => LoginPage()),
                              );
                            } else if (data.containsKey("typeError") &&
                                data["typeError"] == "conflitRoom") {
                              try {
                                await ref
                                    .read(getOrderWithTicketIdUser.notifier)
                                    .loadTicket();

                                navigator.push(
                                  MaterialPageRoute(
                                    builder: (_) => HomeCreen(index: 2),
                                  ),
                                );
                              } catch (error) {
                                showSnackbar(
                                  title: "Lỗi hệ thống",
                                  message: "$error",
                                  type: "error",
                                );
                              }
                            }
                          },
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

                      final seatUser = data["data"]["seatUser"] != null
                          ? HoldingSeat.fromJson(data["data"]["seatUser"])
                          : null;

                      final List<String> seatsDiff =
                          (data["data"]["seatsDiff"] as List)
                              .map((s) => s.toString())
                              .toList();

                      final List<String> bookedSeat =
                          (dataBooked["data"]["booked"] as List)
                              .map((s) => s.toString())
                              .toList();

                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => BookingPage(
                            movie: detailCinemaState.movie,
                            movieRoom: movieRoom,
                            cinema: widget.cinema,
                            room: r,
                            seatUser: seatUser,
                            seatsDiff: seatsDiff,
                            booked: bookedSeat,
                          ),
                        ),
                      );
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
                  }, Text("Phòng ${r.roomNumber}", style: style));
                }).toList(),
              ),
            ],
          ),
        ),
        Divider(thickness: 2.5, color: Colors.white30),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: colorTextApp),
      title: Text(
        "${widget.cinema.name}",
        style: tilteStyleApp,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgApp = ref.read(backgroundMovieHot.notifier).state;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: appBar(),
      body: Stack(
        children: [
          if (bgApp.isNotEmpty) ...backgroundApp(bgApp),
          SafeArea(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: spacingMedium,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      "${widget.cinema.address}",
                      style: const TextStyle(
                        fontSize: textfontSizeNote,
                        fontWeight: fontWeightNormal,
                        color: colorTextApp,
                        letterSpacing: letterSpacingSmall,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                const SizedBox(height: spacingMedium),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingMedium,
                      ),
                      child: buildDayofCinema(
                        date: date,
                        selectedDate: selectedDate,
                        funcGetData: getMovieDate,
                        onSelectDate: (index, newDate) => setState(() {
                          selectedDate = index;
                          date = newDate;
                          params = DetailCinemaParams(
                            cinemaId: widget.cinema.idCinema!,
                            date: DateFormat("dd/MM/yyyy").format(date),
                          );
                        }),
                      ),
                    ),
                    const Divider(thickness: 0.7, color: hexColorPlaceHolder),
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => await getMovieDate(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        if (detailCinemaState.isNotEmpty)
                          ...List.generate(detailCinemaState.length, (index) {
                            final dateMovieRoom =
                                detailCinemaState[index].movieRooms[index].date;

                            final formatDateMovieRoom = parseDate(
                              dateMovieRoom ?? "",
                            );

                            if (formatDateMovieRoom == date) {
                              return buildItem(
                                detailCinemaState[index],
                                detailCinemaState[index].rooms,
                              );
                            }
                            return const SizedBox.shrink();
                          })
                        else
                          Center(
                            child: Text(
                              "Không có lịch chiếu nào.",
                              style: TextStyle(
                                fontSize: textfontSizeApp,
                                color: colorTextApp,
                                letterSpacing: letterSpacingSmall,
                                fontWeight: fontWeightNormal,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
