import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/provider/cinema.dart';
import 'package:ceni_fruit/provider/movie.dart';
import 'package:flutter/material.dart';
import 'package:ceni_fruit/detail_cinema_page.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CinemaPage extends ConsumerStatefulWidget {
  const CinemaPage({super.key});

  @override
  ConsumerState<CinemaPage> createState() => _CinemaPageState();
}

class _CinemaPageState extends ConsumerState<CinemaPage> {
  List<Cinema> allCinemas = [];
  List<Cinema> cinemasSearch = [];

  var inputSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  PreferredSize buildSearch() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        margin: const EdgeInsets.only(top: spacingBig),
        height: 50,
        width: MediaQuery.of(context).size.width - 60,
        alignment: Alignment.center,
        child: TextField(
          style: const TextStyle(
            fontSize: textfontSizeApp,
            fontWeight: fontWeightMedium,
            letterSpacing: letterSpacingSmall,
          ),
          controller: inputSearch,
          textAlign: TextAlign.justify,
          decoration: InputDecoration(
            hintText: "Tìm địa chỉ rạp",
            fillColor: colorTextApp,
            filled: true,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: inputSearch.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      inputSearch.clear();
                      funcSearchCinema('');
                      setState(() {});
                    },
                  )
                : null,
            border: const OutlineInputBorder(
              borderRadius: borderRadiusCardSmall,
              borderSide: BorderSide(color: Colors.amberAccent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: borderRadiusCardSmall,
              borderSide: BorderSide(color: Colors.amberAccent),
            ),

            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          onChanged: funcSearchCinema,
        ),
      ),
    );
  }

  Widget titleSiliverAppBar = const Text(
    "Danh sách rạp",
    style: TextStyle(
      color: colorTextApp,
      fontSize: textfontSizeTitleAppBar,
      letterSpacing: letterSpacingSmall,
      fontWeight: fontWeightTitleAppBar,
      shadows: [
        Shadow(color: Colors.purple, blurRadius: 20, offset: Offset(0, 8)),
      ],
    ),
  );

  Widget buildItem(Cinema cinema) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailCinemaPage(cinema: cinema)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: spacingBig),
        padding: const EdgeInsets.all(spacingSmall),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacingMedium,
          children: [
            ClipRRect(
              borderRadius: borderRadiusButton,
              child: CachedNetworkImage(
                imageUrl: cinema.urlImage!,
                width: 90,
                height: 70,
                memCacheWidth: 400,
                memCacheHeight: 600,
                fit: BoxFit.fill,
                placeholder: (context, url) => Center(child: circularProgress),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.broken_image_rounded)),
              ),
            ),
            Expanded(
              child: Column(
                spacing: spacingSmall,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${cinema.name}",
                    style: const TextStyle(
                      fontSize: textfontSizeApp,
                      fontWeight: fontWeightSemiBold,
                      letterSpacing: letterSpacingSmall,
                      color: colorTextApp,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    "${cinema.address}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: textfontSizeNote,
                      fontWeight: fontWeightMedium,
                      letterSpacing: letterSpacingSmall,
                      color: colorTextApp,
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

  @override
  Widget build(BuildContext context) {
    final cinemasAsync = ref.watch(cinemaProvider);
    final bgApp = ref.read(backgroundAppProvider.notifier).state;
    return cinemasAsync.when(
      loading: () => buildLoadingScreen(),
      error: (error, stackTrace) => buildErrorScreen(error),
      data: (cinemas) {
        allCinemas = cinemas;
        if (inputSearch.text.isEmpty) {
          cinemasSearch = List.from(cinemas);
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          body: RefreshIndicator(
            onRefresh: () async {
              return ref.read(cinemaProvider.notifier).refreshCinema();
            },
            child: Stack(
              children: [
                if (bgApp.isNotEmpty) ...backgroundApp(bgApp),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      title: titleSiliverAppBar,
                      backgroundColor: Colors.transparent,
                      bottom: buildSearch(),
                    ),

                    cinemasSearch.isNotEmpty
                        ? SliverPadding(
                            padding: const EdgeInsets.only(top: spacingMedium),
                            sliver: SliverList.builder(
                              itemCount: cinemasSearch.length,
                              itemBuilder: (context, index) =>
                                  buildItem(cinemasSearch[index]),
                            ),
                          )
                        : const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.justify,
                                "Không tìm thấy rạp",
                                style: TextStyle(
                                  color: colorTextApp,
                                  fontSize: textfontSizeApp,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void funcSearchCinema(String input) {
    final result = allCinemas.where((cinema) {
      final dataInput = input.trim().toLowerCase();
      final area = cinema.area!.trim().toLowerCase();
      final address = cinema.address!.trim().toLowerCase();
      return area.contains(dataInput) || address.contains(dataInput);
    }).toList();

    setState(() => cinemasSearch = result);
    return;
  }
}
