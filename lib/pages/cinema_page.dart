import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/button_call_again.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/catch_network_image.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/provider/cinema_provider.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:ceni_fruit/provider/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
      preferredSize: const Size.fromHeight(50),
      child: Container(
        margin: const EdgeInsets.only(top: spacingMedium),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: spacingMedium),
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

  Widget titleSiliverAppBar = const Text("Danh sách rạp", style: tilteStyleApp);

  Widget buildItem(Cinema cinema) {
    return GestureDetector(
      onTap: () async {
        final navigator = Navigator.of(context);
        try {
          Get.dialog(
            Center(child: circularProgress),
            barrierDismissible: false,
          );

          final dateNow = DateTime.now().add(const Duration(days: 1));
          final dateFormat = DateFormat("dd/MM/yyyy");

          final params = DetailCinemaParams(
            cinemaId: cinema.idCinema!,
            date: dateFormat.format(dateNow).toString(),
          );

          await ref
              .read(detailCinemaProvider(params).notifier)
              .loadDetailCinema();

          final state = ref.read(detailCinemaProvider(params));

          if (navigator.canPop()) {
            navigator.pop();
          }
          if (state.hasError) {
            showSnackbar(
              title: "Lỗi hệ thống",
              message: "${state.error}",
              type: "error",
            );
          } else {
            NavigationHelper.goToDetailCinema(
              cinema: cinema,
              detailCinemaState: state.value ?? [],
            );
          }
        } catch (error) {
          if (navigator.canPop()) {
            navigator.pop();
          }
          showSnackbar(title: "Lỗi hệ thống", message: "$error", type: "error");
        }
      },
      child: Container(
        padding: const EdgeInsets.only(
          right: spacingMedium,
          left: spacingMedium,
          bottom: spacingBig,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacingMedium,
          children: [
            ClipRRect(
              borderRadius: borderRadiusCardSmall,
              child: cachedNetworkImageConfig(
                cinema.urlImage!,
                90,
                70,
                BoxFit.fill,
                iconfontSizeNormal,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfile);
    final bgApp = ref.read(backgroundMovieHot.notifier).state;
    final cinemasAsync = ref.watch(cinemaProvider);
    return cinemasAsync.when(
      loading: () => buildLoadingScreen(bgApp),
      error: (error, stackTrace) {
        if (userProfileState.value?.role == "admin") {
          return buildErrorScreen(
            error,
            stackTrace,
            () => ref.read(cinemaProvider.notifier).refreshCinema(),
          );
        } else {
          return buttonCallAgain(
            AppBar(
              title: Text("Danh sách rạp", style: tilteStyleApp),
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: colorTextApp),
              centerTitle: false,
            ),
            bgApp,
            () => ref.read(cinemaProvider.notifier).refreshCinema(),
          );
        }
      },
      data: (cinemas) {
        allCinemas = cinemas;
        if (inputSearch.text.isEmpty) {
          cinemasSearch = List.from(cinemas);
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: () async {
              return ref.read(cinemaProvider.notifier).refreshCinema();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (bgApp.isNotEmpty) ...backgroundApp(bgApp),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      title: titleSiliverAppBar,
                      centerTitle: false,
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
                                  letterSpacing: letterSpacingSmall,
                                  fontWeight: fontWeightNormal,
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
