import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/data/area.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/provider/cinema.dart';
import 'package:ceni_fruit/provider/movie_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  final Movie movie;
  const DetailMovieScreen({super.key, required this.movie});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  String? videoId;
  List<Cinema> cinemas = [];
  List<Cinema> fillterCinemas = [];
  List<MovieRoom> movieRoom = [];

  YoutubePlayerController? youtubePlayerController;

  int currentSegment = 0;
  int selectArea = 0;
  int selectCinema = 0;

  String showTimeCinema = "";
  bool errorImage = false;

  @override
  void initState() {
    super.initState();
    loadMovieRoom().then((_) {
      loadCinemas();
    });

    videoId = YoutubePlayer.convertUrlToId(widget.movie.video!);

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

  Future<String> loadCinemas() async {
    cinemas = await ReadData().loadCinema();
    fillterCinemas =
        cinemas
            .where(
              (cinema) => movieRoom.any(
                (mr) => widget.movie.id == mr.idMovie && cinema.id == mr.idRoom,
              ),
            )
            .toList();
    fillterCinemas.isNotEmpty
        ? fillterCinemas.insert(0, Cinema(name: "Tất cả rạp"))
        : fillterCinemas = [];
    setState(() {});
    return "";
  }

  Future<String> loadMovieRoom() async {
    movieRoom = await ReadDataJsonMovieRoom().loadMovieRoom();
    setState(() {});
    return "";
  }

  static const styleTextSlidingSegmnet = TextStyle(
    fontSize: textfontSizeApp,
    fontWeight: FontWeight.bold,
  );

  Map<int, Widget> slidingSegments = <int, Widget>{
    0: Text("Suất chiếu", style: styleTextSlidingSegmnet),
    1: Text("Thông tin", style: styleTextSlidingSegmnet),
  };

  handleFillterCinemas(index, bool cinemaAndArea) {
    setState(() {
      if (cinemaAndArea) {
        selectArea = index;
        fillterCinemas =
            cinemas
                .where(
                  (cinema) => movieRoom.any(
                    (mr) =>
                        widget.movie.id == mr.idMovie &&
                        cinema.id == mr.idRoom &&
                        cinema.area.toString().trim().toLowerCase() ==
                            areas[index].toString().trim().toLowerCase(),
                  ),
                )
                .toList();

        if (selectArea == 0) {
          fillterCinemas =
              cinemas
                  .where(
                    (cinema) => movieRoom.any(
                      (mr) =>
                          widget.movie.id == mr.idMovie &&
                          cinema.id == mr.idRoom,
                    ),
                  )
                  .toList();
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

  handleShowName(String type) {
    bool cinemaAndArea = type == "area" ? true : false;
    if (cinemaAndArea) {
      var name = selectArea == 0 ? "Chọn khu vực" : areas[selectArea];
      return name;
    }
    return fillterCinemas.isNotEmpty
        ? fillterCinemas[selectCinema].name
        : "Không có rạp";
  }

  handleShowList(String type) {
    bool cinemaAndArea = type == "area" ? true : false;
    var textStyle = TextStyle(
      color: colorTextApp,
      fontSize: textfontSizeTitleAppBar,
      fontWeight: FontWeight.bold,
    );
    if (cinemaAndArea) {
      return areas
          .map((area) => Center(child: Text(area, style: textStyle)))
          .toList();
    }

    return fillterCinemas
        .map((cinema) => Center(child: Text(cinema.name!, style: textStyle)))
        .toList();
  }

  Widget buildChooseCinemaArea(String type) {
    bool cinemaAndArea = type == "area" ? true : false;
    return Expanded(
      child: CupertinoButton(
        color: navBarColor,
        child: Text(
          handleShowName(type),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            color: colorTextApp,
            fontSize: textfontSizeApp,
          ),
        ),
        onPressed:
            () =>
                (!cinemaAndArea && fillterCinemas.isEmpty)
                    ? {}
                    : showCupertinoModalPopup(
                      context: context,
                      builder:
                          (_) => Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 350,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 3,
                                    sigmaY: 3,
                                  ),
                                  child: CupertinoPicker(
                                    backgroundColor: Colors.transparent,
                                    itemExtent: 40,
                                    offAxisFraction: -0.8,
                                    diameterRatio: 1,
                                    squeeze: 1,
                                    scrollController:
                                        FixedExtentScrollController(
                                          initialItem:
                                              cinemaAndArea
                                                  ? selectArea
                                                  : selectCinema,
                                        ),
                                    onSelectedItemChanged:
                                        (index) => handleFillterCinemas(
                                          index,
                                          cinemaAndArea,
                                        ),
                                    children: handleShowList(type),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
      ),
    );
  }

  Widget buildMovieShow() {
    var cinemasFiltered =
        fillterCinemas.where((cinema) => cinema.name != "Tất cả rạp").toList();
    if (selectCinema != 0) {
      cinemasFiltered =
          cinemasFiltered
              .where((c) => c.id == fillterCinemas[selectCinema].id)
              .toList();
    }

    return Container(
      color: errorImage ? bgColorApp : navBarColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: spacing,
            children: [
              buildChooseCinemaArea("area"),
              Container(
                height: 25,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
              buildChooseCinemaArea("cinema"),
            ],
          ),
          const Divider(thickness: 0.5, color: Colors.grey),
          cinemasFiltered.isNotEmpty
              ? Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 10),
                  itemCount: cinemasFiltered.length,
                  itemBuilder: (context, index) {
                    return buildItem(cinemasFiltered[index]);
                  },
                ),
              )
              : const Text(
                "Không có rạp nào.",
                style: TextStyle(
                  color: colorTextApp,
                  fontSize: textfontSizeApp,
                ),
              ),
        ],
      ),
    );
  }

  Widget buildMovieInfo() {
    style_({double? textSize, Color? color}) {
      return TextStyle(
        fontSize: textSize ?? textfontSizeNote,
        fontFamily: "monospace",
        fontWeight: FontWeight.bold,
        color: color ?? Colors.white,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool videoIsValid = youtubePlayerController != null;
        return SingleChildScrollView(
          child: Column(
            spacing: spacing,
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
                  right: 8,
                  left: 8,
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
                padding: const EdgeInsets.symmetric(horizontal: spacing),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: spacing,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 190,
                      child: ClipRRect(
                        borderRadius: borderRadiusButton,
                        child: CachedNetworkImage(
                          imageUrl: widget.movie.urlImage!,
                          fit: BoxFit.fill,
                          errorWidget:
                              (context, url, error) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Failed image',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: spacing,
                        children: [
                          Text(
                            widget.movie.name ?? "",
                            style: style_(textSize: textfontSizeApp),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.star_rate_rounded,
                                color: Colors.amber,
                              ),
                              Text("${widget.movie.rate}/10", style: style_()),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: spacing,
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
                                onTap: () {},
                                child: Text(
                                  "Đánh giá",
                                  style: style_(color: Colors.cyanAccent),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: spacing,
                            children: [
                              const Icon(
                                Icons.history_rounded,
                                color: Colors.amber,
                              ),
                              Text("${widget.movie.duration}", style: style_()),
                            ],
                          ),
                          Row(
                            spacing: spacing,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.amber,
                              ),
                              Text(
                                "${widget.movie.releaseDate}",
                                style: style_(),
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
                  left: spacing,
                  right: spacing,
                  bottom: spacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 3,
                  children: [
                    Text(
                      "Nội dung:",
                      style: style_(textSize: textfontSizeTitleAppBar),
                    ),
                    Text("${widget.movie.description}", style: style_()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildShowTimeMovie(time) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: borderRadiusButton,
          color: colorTextApp,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textfontSizeNote,
              fontFamily: fontApp,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(cinema) {
    var iconArrowOpenShowTime =
        showTimeCinema != cinema.id
            ? Icons.keyboard_arrow_down_rounded
            : Icons.keyboard_arrow_up_rounded;

    final filteredRooms =
        movieRoom
            .where(
              (mr) => mr.idRoom == cinema.id && mr.idMovie == widget.movie.id,
            )
            .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (showTimeCinema == cinema.id && showTimeCinema.isNotEmpty) {
                  showTimeCinema = "";
                  return;
                }
                showTimeCinema = cinema.id;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      cinema.name,
                      style: const TextStyle(
                        color: colorTextApp,
                        fontSize: textfontSizeApp,
                      ),
                    ),
                  ),

                  Icon(
                    iconArrowOpenShowTime,
                    size: iconfontSizeApp,
                    color: colorTextApp,
                  ),
                ],
              ),
            ),
          ),
          (showTimeCinema.isNotEmpty && showTimeCinema == cinema.id)
              ? filteredRooms.isEmpty
                  ? const Text(
                    "Không có lịch chiếu nào.",
                    style: TextStyle(
                      color: colorTextApp,
                      fontWeight: FontWeight.w500,
                      fontSize: textfontSizeNote,
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 15,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: spacing,
                        children:
                            filteredRooms
                                .map((mr_) => buildShowTimeMovie(mr_.time))
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
      title:
          currentSegment == 0
              ? Text(
                widget.movie.name!,
                style: TextStyle(
                  color: colorTextApp,
                  fontSize: textfontSizeTitleAppBar,
                ),
              )
              : null,

      backgroundColor: errorImage ? bgColorApp : Colors.transparent,
      iconTheme: const IconThemeData(color: colorTextApp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: errorImage ? bgColorApp : Colors.transparent,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: widget.movie.urlImage!,
                fit: BoxFit.fill,
                errorWidget: (context, url, error) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => errorImage = true);
                  });
                  return const Center(child: Icon(Icons.broken_image));
                },
              ),
            ),

            if (!errorImage) ...overlayLayers(),

            Padding(
              padding: EdgeInsets.only(
                top: currentSegment == 0 ? 140 : 0,
                right: currentSegment == 0 ? 15 : 0,
                left: currentSegment == 0 ? 15 : 0,
              ),
              child: currentSegment == 0 ? buildMovieShow() : buildMovieInfo(),
            ),

            if (currentSegment == 0)
              Positioned(
                top: currentSegment == 0 ? 108 : 230,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CupertinoSlidingSegmentedControl(
                    groupValue: currentSegment,
                    children: slidingSegments,
                    onValueChanged: (value) {
                      setState(() => currentSegment = value!);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

List<Widget> overlayLayers() {
  return [
    Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.35),
              Colors.white.withOpacity(0.10),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ),
    Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: SizedBox.shrink(),
      ),
    ),
    Positioned.fill(child: Container(color: Colors.black.withOpacity(0.10))),
  ];
}
