import 'dart:ui';

import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/day_of_cinema.dart';
import 'package:ceni_fruit/config/popup_rating_movie.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/style_button.dart';
import 'package:ceni_fruit/config/catch_network_image.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/model/booking.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/detail_movie.dart';
import 'package:ceni_fruit/model/holding_seat.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/room.dart';
import 'package:ceni_fruit/provider/cinema_provider.dart';
import 'package:ceni_fruit/provider/holding_seat_provider.dart';
import 'package:ceni_fruit/provider/order_provider.dart';
import 'package:ceni_fruit/provider/movie_room_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends ConsumerStatefulWidget {
  final DetailMovie detailMovie;
  const DetailMovieScreen({super.key, required this.detailMovie});

  @override
  ConsumerState<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends ConsumerState<DetailMovieScreen> {
  late Movie movie;
  late List<Cinema> cinemas;
  late List<Room> rooms;
  late List<MovieRoom> movieRooms;
  double score = 0;

  late GetMovieParams params;

  String? videoId;
  int selectedDate = 0;
  DateTime date = DateUtils.dateOnly(
    DateTime.now().add(const Duration(days: 1)),
  );

  List<Cinema> fillterCinemas = [];

  List<String> cinemasArea = [];

  YoutubePlayerController? youtubePlayerController;

  int currentSegment = 0;
  int selectArea = 0;
  int selectCinema = 0;

  String enableShowRoom = "";

  @override
  void initState() {
    super.initState();

    movie = widget.detailMovie.movie;
    cinemas = widget.detailMovie.cinemas;
    movieRooms = widget.detailMovie.movieRooms;
    rooms = widget.detailMovie.rooms;
    fillterCinemas = widget.detailMovie.cinemas;
    cinemasArea = widget.detailMovie.cinemas.isNotEmpty
        ? widget.detailMovie.cinemas
              .where((c) => c.area != null)
              .map((c) => c.area!)
              .toList()
        : [];
    if (cinemasArea.isNotEmpty && cinemasArea.first != "Toàn quốc") {
      cinemasArea.insert(0, "Toàn quốc");
      cinemasArea = cinemasArea.toSet().toList();
    }

    params = GetMovieParams(
      idMovie: widget.detailMovie.movie.idMovie!,
      date: DateFormat("dd/MM/yyyy").format(date),
    );

    videoId = YoutubePlayer.convertUrlToId(widget.detailMovie.movie.video!);

    if (videoId != null && videoId!.isNotEmpty) {
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: YoutubePlayerFlags(autoPlay: false),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (youtubePlayerController != null) {
      youtubePlayerController!.dispose();
    }
  }

  Future<void> funcHanldeToBooking(Room room, Cinema cinema) async {
    final navigator = Navigator.of(context);
    try {
      Get.dialog(Center(child: circularProgress), barrierDismissible: false);

      final movieRoom = movieRooms.firstWhere(
        (mr) => mr.idMovie == movie.idMovie && mr.idRoom.idRoom == room.idRoom,
      );

      final data = await ref
          .read(holdingSeatServiceProvider)
          .getSelectedSeat(movieRoom.idMovieRoom!);

      final dataBooked = await ref
          .read(orderServiceProvider)
          .getBooked(room.idRoom!, movie.idMovie!);

      if (navigator.canPop()) {
        navigator.pop();
      }

      if (!data["success"]) {
        showSnackbar(
          title: "Tài khoản",
          message: data["message"],
          type: "error",
          func: () => NavigationHelper.goToLogin(returnRoute: '/detail_movie'),
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

      final List<String> seatsDiff = (data["data"]["seatsDiff"] as List)
          .map((s) => s.toString())
          .toList();

      final List<String> bookedSeat = (dataBooked["data"]["booked"] as List)
          .map((s) => s.toString())
          .toList();

      Booking params = Booking(
        movie: movie,
        movieRoom: movieRoom,
        cinema: cinema,
        room: room,
        seatUser: seatUser,
        seatsDiff: seatsDiff,
        booked: bookedSeat,
      );

      NavigationHelper.goToBooking(booking: params);
    } catch (error) {
      if (navigator.canPop()) {
        navigator.pop();
      }
      showSnackbar(title: "Lỗi hệ thống", message: "$error", type: "error");
    }
  }

  Map<int, Widget> buildSlidingSegments() {
    return <int, Widget>{
      0: Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          "Suất chiếu",
          style: TextStyle(
            color: currentSegment == 0 ? hexColorTextBlack : colorTextApp,
            fontSize: textfontSizeApp,
            fontWeight: fontWeightMedium,
            letterSpacing: letterSpacingSmall,
          ),
        ),
      ),
      1: Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          "Thông tin",
          style: TextStyle(
            color: currentSegment == 1 ? hexColorTextBlack : colorTextApp,
            fontSize: textfontSizeApp,
            fontWeight: fontWeightMedium,
            letterSpacing: letterSpacingSmall,
          ),
        ),
      ),
    };
  }

  handleFillterCinemas(index, bool cinemaAndArea) {
    setState(() {
      if (cinemaAndArea) {
        selectArea = index;

        fillterCinemas = cinemas.where((cinema) {
          return cinema.area == cinemasArea[index];
        }).toList();

        if (selectArea == 0) {
          fillterCinemas = cinemas;
        }

        selectCinema = 0;
      } else {
        selectCinema = index;
      }
      if (fillterCinemas.isNotEmpty && fillterCinemas[0].name != "Tất cả rạp") {
        fillterCinemas.isNotEmpty
            ? fillterCinemas.insert(0, Cinema(name: "Tất cả rạp"))
            : fillterCinemas = [];
      }
    });
  }

  Future<void> funcGetData() async {
    Get.dialog(Center(child: circularProgress), barrierDismissible: false);

    await ref.read(movieRoomProvider(params).notifier).loadMovieRoomIdMovie();
    final state = ref.read(movieRoomProvider(params));

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
        movie = value!.movie;
        cinemas = value.cinemas;
        movieRooms = value.movieRooms;
        rooms = value.rooms;
        fillterCinemas = value.cinemas;
        cinemasArea = value.cinemas.isNotEmpty
            ? value.cinemas
                  .where((c) => c.area != null)
                  .map((c) => c.area!)
                  .toList()
            : [];
        if (fillterCinemas.isNotEmpty &&
            fillterCinemas.first.name != "Tất cả rạp") {
          fillterCinemas.insert(0, Cinema(name: "Tất cả rạp"));
        }
        if (cinemasArea.isNotEmpty && cinemasArea.first != "Toàn quốc") {
          cinemasArea.insert(0, "Toàn quốc");
          cinemasArea = cinemasArea.toSet().toList();
        }
      });
    }
  }

  handleShowName(String type) {
    bool cinemaAndArea = type == "area" ? true : false;
    if (cinemaAndArea) {
      var name = selectArea == 0 ? "Chọn khu vực" : cinemasArea[selectArea];
      return name;
    }
    return fillterCinemas.isNotEmpty
        ? fillterCinemas[selectCinema].name
        : "Không có rạp";
  }

  handleShowList(String type) {
    bool cinemaAndArea = type == "area" ? true : false;
    var textStyle = TextStyle(
      color: hexColorTextBlack,
      fontSize: textfontSizeTitleAppBar,
      fontWeight: FontWeight.bold,
    );
    if (cinemaAndArea) {
      return cinemasArea
          .map((ca) => Center(child: Text(ca, style: textStyle)))
          .toList();
    }

    return fillterCinemas
        .map((cinema) => Center(child: Text(cinema.name!, style: textStyle)))
        .toList();
  }

  Widget buildChooseCinemaArea(String type) {
    bool cinemaAndArea = type == "area";
    return Expanded(
      child: CupertinoButton(
        color: Colors.transparent,
        padding: EdgeInsets.zero,
        child: Text(
          handleShowName(type),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: colorTextApp,
            fontSize: textfontSizeApp,
            fontWeight: fontWeightMedium,
            letterSpacing: letterSpacingSmall,
          ),
        ),
        onPressed: () =>
            ((!cinemaAndArea && fillterCinemas.isEmpty) ||
                (cinemaAndArea && cinemasArea.isEmpty))
            ? {}
            : showCupertinoModalPopup(
                context: context,
                builder: (_) => CupertinoActionSheet(
                  actions: [
                    SizedBox(
                      height: 300,
                      child: CupertinoPicker(
                        backgroundColor: colorTextApp,
                        itemExtent: 64,
                        selectionOverlay:
                            CupertinoPickerDefaultSelectionOverlay(
                              background: CupertinoColors.activeBlue
                                  .withOpacity(0.2),
                            ),
                        scrollController: FixedExtentScrollController(
                          initialItem: cinemaAndArea
                              ? selectArea
                              : selectCinema,
                        ),
                        onSelectedItemChanged: (index) =>
                            handleFillterCinemas(index, cinemaAndArea),
                        children: handleShowList(type),
                      ),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    isDefaultAction: true,
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context),
                    child: Text("Quay lại"),
                  ),
                ),
              ),
      ),
      // child: CupertinoButton(
      //   color: Colors.transparent,
      //   padding: EdgeInsets.zero,
      //   child: Text(
      //     handleShowName(type),
      //     overflow: TextOverflow.ellipsis,
      //     maxLines: 1,
      //     textAlign: TextAlign.center,
      //     style: const TextStyle(
      //       color: colorTextApp,
      //       fontSize: textfontSizeApp,
      //       fontWeight: fontWeightMedium,
      //       letterSpacing: letterSpacingSmall,
      //     ),
      //   ),
      //   onPressed: () =>
      //       ((!cinemaAndArea && fillterCinemas.isEmpty) ||
      //           (cinemaAndArea && cinemasArea.isEmpty))
      //       ? {}
      //       : showCupertinoModalPopup(
      //           context: context,
      //           builder: (_) => Expanded(
      //             child: Align(
      //               alignment: Alignment.bottomCenter,
      //               child: SizedBox(
      //                 height: 350,
      //                 child: BackdropFilter(
      //                   filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      //                   child: CupertinoPicker(
      //                     backgroundColor: colorTextApp,
      //                     itemExtent: 40,
      //                     offAxisFraction: -0.8,
      //                     diameterRatio: 1,
      //                     squeeze: 1,
      //                     scrollController: FixedExtentScrollController(
      //                       initialItem: cinemaAndArea
      //                           ? selectArea
      //                           : selectCinema,
      //                     ),
      //                     onSelectedItemChanged: (index) =>
      //                         handleFillterCinemas(index, cinemaAndArea),
      //                     children: handleShowList(type),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      // ),
    );
  }

  Widget buildMovieShow() {
    var cinemasFiltered = fillterCinemas
        .where((cinema) => cinema.name != "Tất cả rạp")
        .toList();
    if (selectCinema != 0) {
      cinemasFiltered = cinemasFiltered
          .where((c) => c.idCinema == fillterCinemas[selectCinema].idCinema)
          .toList();
    }

    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildChooseCinemaArea("area"),
                Container(
                  height: 25,
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: hexColorPlaceHolder, width: 2),
                    ),
                  ),
                ),
                buildChooseCinemaArea("cinema"),
              ],
            ),
          ),
          const SizedBox(height: spacingMedium),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacingMedium),
                child: buildDayofCinema(
                  selectedDate: selectedDate,
                  date: date,
                  funcGetData: funcGetData,
                  onSelectDate: (index, newDate) => setState(() {
                    selectedDate = index;
                    date = newDate;
                    params = GetMovieParams(
                      idMovie: widget.detailMovie.movie.idMovie!,
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
              onRefresh: () async => await funcGetData(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  if (cinemasFiltered.isNotEmpty)
                    ...List.generate(cinemasFiltered.length, (index) {
                      return buildItem(cinemasFiltered[index], rooms);
                    })
                  else
                    Center(
                      child: const Text(
                        "Không có rạp nào.",
                        style: TextStyle(
                          color: colorTextApp,
                          fontSize: textfontSizeApp,
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
    );
  }

  Widget buildMovieInfo() {
    const style = TextStyle(
      fontWeight: fontWeightNormal,
      color: colorTextApp,
      letterSpacing: letterSpacingSmall,
      fontSize: textfontSizeNote,
    );

    final slidingSegments = buildSlidingSegments();
    return LayoutBuilder(
      builder: (context, constraints) {
        bool videoIsValid = youtubePlayerController != null;
        return SingleChildScrollView(
          child: Column(
            spacing: spacingMedium,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (videoIsValid)
                YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: youtubePlayerController!,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(isExpanded: true),
                      RemainingDuration(),
                      const PlaybackSpeedButton(),
                      FullScreenButton(),
                    ],
                  ),
                  builder: (context, player) => Container(child: player),
                ),
              Padding(
                padding: EdgeInsets.only(
                  right: spacingMedium,
                  left: spacingMedium,
                  top: videoIsValid ? 0 : 120,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoSlidingSegmentedControl(
                    groupValue: currentSegment,
                    children: slidingSegments,
                    onValueChanged: (value) {
                      setState(() => currentSegment = value!);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacingMedium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: spacingMedium,
                  children: [
                    ClipRRect(
                      borderRadius: borderRadiusCardSmall,
                      child: cachedNetworkImageConfig(
                        widget.detailMovie.movie.urlImage!,
                        130,
                        190,
                        BoxFit.fill,
                        iconfontSizeNormal,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: spacingMedium,
                        children: [
                          Text(
                            widget.detailMovie.movie.name ?? "",
                            style: const TextStyle(
                              fontSize: textfontSizeApp,
                              fontWeight: fontWeightSemiBold,
                              color: Colors.white,
                              letterSpacing: letterSpacingSmall,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.star_rate_rounded,
                                color: colorIcon,
                              ),
                              Text(
                                "${widget.detailMovie.movie.rate} / 5",
                                style: style,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: spacingMedium,
                                ),
                                height: 15,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      width: 2,
                                      color: colorTextApp,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  DetailCinemaState detailCinemaState =
                                      DetailCinemaState(
                                        cinema: null,
                                        movieRooms: movieRooms,
                                        movie: movie,
                                        rooms: rooms,
                                      );
                                  await popupRatingMovie(
                                    ref: ref,
                                    detailCinemaState: detailCinemaState,
                                    onScoreChanged: (value) {
                                      setState(() {
                                        score = value;
                                      });
                                    },
                                    getMovieDate: () async {
                                      await funcGetData();
                                    },
                                  );
                                },
                                child: Text(
                                  "Đánh giá",
                                  style: styleTextSpecial,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: spacingMedium,
                            children: [
                              const Icon(
                                Icons.history_rounded,
                                color: Colors.amber,
                              ),
                              Text(
                                "${widget.detailMovie.movie.duration} phút",
                                style: style,
                              ),
                            ],
                          ),
                          Row(
                            spacing: spacingMedium,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.amber,
                              ),
                              Text(
                                "${widget.detailMovie.movie.releaseDate}",
                                style: style,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: spacingMedium,
                  right: spacingMedium,
                  bottom: spacingMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: spacingSmall,
                  children: [
                    Text(
                      "Nội dung:",
                      style: const TextStyle(
                        fontSize: textfontSizeApp,
                        fontWeight: fontWeightMedium,
                        letterSpacing: letterSpacingSmall,
                        color: colorTextApp,
                      ),
                    ),
                    Text(
                      "${widget.detailMovie.movie.description}",
                      style: const TextStyle(
                        fontSize: textfontSizeApp,
                        fontWeight: fontWeightNormal,
                        letterSpacing: letterSpacingSmall,
                        color: colorTextApp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildShowRoomMovie(Cinema cinema, Room room) {
    return customElevatedButtonBgTransparent(
      () => funcHanldeToBooking(room, cinema),

      Text(
        "Phòng ${room.roomNumber}",
        style: const TextStyle(
          fontWeight: fontWeightNormal,
          color: colorTextApp,
          letterSpacing: letterSpacingSmall,
          fontSize: textfontSizeNote,
        ),
      ),
    );
  }

  Widget buildItem(Cinema cinema, List<Room> rooms) {
    var iconArrowOpenShowTime = enableShowRoom != cinema.idCinema
        ? Icons.keyboard_arrow_down_rounded
        : Icons.keyboard_arrow_up_rounded;

    return Container(
      padding: const EdgeInsets.all(spacingMedium),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (enableShowRoom == cinema.idCinema &&
                    enableShowRoom.isNotEmpty) {
                  enableShowRoom = "";
                  return;
                }
                enableShowRoom = cinema.idCinema!;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: spacingMedium),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${cinema.name}",
                      style: const TextStyle(
                        color: colorTextApp,
                        fontSize: textfontSizeApp,
                        letterSpacing: letterSpacingSmall,
                        fontWeight: fontWeightNormal,
                      ),
                    ),
                  ),

                  Icon(
                    iconArrowOpenShowTime,
                    size: iconfontSizeNormal,
                    color: colorTextApp,
                  ),
                ],
              ),
            ),
          ),
          (rooms.isNotEmpty && enableShowRoom == cinema.idCinema)
              ? rooms.isEmpty
                    ? const Text(
                        "Không có lịch chiếu nào.",
                        style: TextStyle(
                          color: colorTextApp,
                          fontWeight: fontWeightMedium,
                          fontSize: textfontSizeApp,
                          letterSpacing: letterSpacingSmall,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: spacingMedium),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: spacingMedium,
                            children: rooms
                                .where(
                                  (rConditional) =>
                                      rConditional.idCinema == cinema.idCinema,
                                )
                                .map((r) => buildShowRoomMovie(cinema, r))
                                .toList(),
                          ),
                        ),
                      )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: currentSegment == 0
          ? Text(widget.detailMovie.movie.name!, style: tilteStyleApp)
          : null,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: colorTextApp),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slidingSegments = buildSlidingSegments();

    return Scaffold(
      appBar: buildAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: bgColorApp,

      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ...backgroundApp(widget.detailMovie.movie.urlImage!),

            if (currentSegment == 0) ...[
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingMedium,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: currentSegment,
                          children: slidingSegments,
                          onValueChanged: (value) {
                            if (value != null) {
                              setState(() => currentSegment = value);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: spacingMedium),
                    Expanded(child: buildMovieShow()),
                  ],
                ),
              ),
            ] else ...[
              buildMovieInfo(),
            ],
          ],
        ),
      ),
    );
  }
}
