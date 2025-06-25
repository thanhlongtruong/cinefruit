import 'package:ceni_fruit/pages/booking_page.dart';
import 'package:ceni_fruit/provider/order.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/room.dart';
import 'package:ceni_fruit/provider/movie.dart';
import 'package:ceni_fruit/provider/movie_room.dart';
import 'package:ceni_fruit/provider/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailCinemaPage extends ConsumerStatefulWidget {
  final Cinema cinema;
  const DetailCinemaPage({super.key, required this.cinema});

  @override
  ConsumerState<DetailCinemaPage> createState() => _DetailCinemaPageState();
}

class _DetailCinemaPageState extends ConsumerState<DetailCinemaPage> {
  int selectedDate = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Map<String, String>> getList30Days() {
    final now = DateTime.now();
    final formatDM = DateFormat("dd/MM");
    final weekdayFormat = DateFormat('EEE', 'vi_VN');

    return List.generate(30, (i) {
      final date = DateTime(now.year, now.month, now.day + i);
      return {
        "daymonth": formatDM.format(date),
        "weekday": i == 0 ? "Hôm nay" : weekdayFormat.format(date),
      };
    });
  }

  Widget buildDayofCinema() {
    final List<Map<String, String>> days = getList30Days();
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white30)),
      ),
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedDate;
          final item = days[index];
          final weekday = item['weekday'] ?? '';
          final daymonth = item['daymonth'] ?? '';
          return GestureDetector(
            onTap: () => setState(() => selectedDate = index),
            child: Column(
              spacing: spacingSmall,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacingMedium,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[900] : Colors.transparent,
                      borderRadius: borderRadiusButton,
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingBig,
                        vertical: spacingSmall,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weekday,
                            style: TextStyle(
                              color: colorTextApp,
                              fontWeight: fontWeightNormal,
                              fontSize: textfontSizeSmall,
                              letterSpacing: letterSpacingSmall,
                            ),
                          ),
                          Text(
                            daymonth,
                            style: TextStyle(
                              color: colorTextApp,
                              fontWeight: fontWeightMedium,
                              fontSize: textfontSizeNote,
                              letterSpacing: letterSpacingSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildItem(
    Movie movie,
    List<MovieRoom> lstMovieRoom,
    List<Room> rooms,
  ) {
    final movieRoom = lstMovieRoom
        .where((mr) => mr.idMovie == movie.id)
        .toList();
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
                    borderRadius: borderRadiusButton,
                    child: CachedNetworkImage(
                      imageUrl: movie.urlImage!,
                      height: 115,
                      width: 77,
                      fit: BoxFit.contain,
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
                            "${movie.name}",
                            style: const TextStyle(
                              fontWeight: fontWeightMedium,
                              color: colorTextApp,
                              letterSpacing: letterSpacingSmall,
                              fontSize: textfontSizeApp,
                            ),
                          ),
                        ),
                        Row(
                          spacing: spacingSmall,
                          children: [
                            const Icon(
                              Icons.history_outlined,
                              color: Colors.amber,
                              size: iconfontSizeApp,
                            ),
                            Text('${movie.duration}', style: style),
                            const SizedBox(width: spacingMedium),
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.amber,
                              size: iconfontSizeApp,
                            ),
                            Text("${movie.releaseDate}", style: style),
                          ],
                        ),

                        Row(
                          spacing: spacingSmall,
                          children: [
                            const Icon(
                              Icons.star_rate_rounded,
                              color: Colors.yellow,
                              size: iconfontSizeApp,
                            ),
                            Text('${movie.rate} /10', style: style),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: spacingMedium,
                children: movieRoom.map((mr) {
                  final room = rooms.firstWhere(
                    (r) => r.id == mr.idRoom,
                    orElse: () => throw Exception(
                      "Không tìm thấy room với id ${mr.idRoom}",
                    ),
                  );

                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: borderRadiusButton,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingPage(
                            movie: movie,
                            movieRoom: mr,
                            cinema: widget.cinema,
                            room: room,
                          ),
                        ),
                      );
                    },
                    child: Text("Phòng ${mr.idRoom}", style: style),
                  );
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
        style: const TextStyle(
          color: colorTextApp,
          fontSize: textfontSizeTitleAppBar,
          letterSpacing: letterSpacingSmall,
          fontWeight: fontWeightTitleAppBar,
          shadows: [
            Shadow(color: Colors.purple, blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgApp = ref.read(backgroundAppProvider);
    final roomsAsync = ref.watch(roomProvider);
    final movieAsync = ref.watch(movieProvider);
    final movieRoomAsync = ref.watch(movieRoomProvider);

    if (roomsAsync.isLoading ||
        movieAsync.isLoading ||
        movieRoomAsync.isLoading) {
      return buildLoadingScreen();
    }

    if (roomsAsync.hasError || movieAsync.hasError || movieRoomAsync.hasError) {
      return buildErrorScreen(
        roomsAsync.error ?? movieAsync.error ?? movieRoomAsync.error,
      );
    }

    final rooms = roomsAsync.value!;
    final movies = movieAsync.value!;
    final movieRoom = movieRoomAsync.value!;
    final idCinema = widget.cinema.id;

    final roomCinema = rooms.where((r) => r.idCinema == idCinema).toList();

    // lay movie_room theo cac phong thuoc rap
    final movieRoomCinema = movieRoom
        .where((mr) => roomCinema.any((rc) => mr.idRoom == rc.id))
        .toList();

    print(movieRoom[0].idRoom);
    // lay phim theo movie_room
    final movieRoomMovie = movies
        .where((mrc) => movieRoomCinema.any((m) => m.idMovie == mrc.id))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(movieProvider.notifier).refresh(),
            ref.read(roomProvider.notifier).refreshRoom(),
            ref.read(movieRoomProvider.notifier).refresh(),
          ]);
        },
        child: Stack(
          children: [
            if (bgApp.isNotEmpty) ...backgroundApp(bgApp),
            SafeArea(
              child: Column(
                spacing: spacingMedium,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
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
                  buildDayofCinema(),
                  movieRoomMovie.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) => buildItem(
                              movieRoomMovie[index],
                              movieRoomCinema,
                              rooms,
                            ),
                            itemCount: movieRoomMovie.length,
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Text(
                              "Không có lịch chiếu nào.",
                              style: TextStyle(
                                fontSize: textfontSizeApp,
                                color: colorTextApp,
                                letterSpacing: letterSpacingSmall,
                                fontWeight: fontWeightMedium,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
