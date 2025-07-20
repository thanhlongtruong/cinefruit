import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:ceni_fruit/provider/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

const style = TextStyle(
  fontWeight: fontWeightNormal,
  color: colorTextApp,
  letterSpacing: letterSpacingSmall,
  fontSize: textfontSizeNote,
);

Future<void> popupRatingMovie({
  required WidgetRef ref,
  required Movie movie,
  required Function(double) onScoreChanged,
  required VoidCallback getMovieDate,
  required String returnRoute,
}) async {
  double score = 0;

  await Get.dialog(
    StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.white,

          insetPadding: EdgeInsets.all(spacingMedium),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusCardSmall),

          title: Column(
            spacing: spacingSmall,
            children: [
              Text(
                "${movie.name}",
                style: TextStyle(
                  fontWeight: fontWeightSemiBold,
                  color: hexColorTextBlack,
                  letterSpacing: letterSpacingSmall,
                  fontSize: textfontSizeTitleAppBar,
                ),
              ),
              Text(
                "Số người đã đánh giá : ${movie.rateCount}",
                style: TextStyle(
                  fontWeight: fontWeightNormal,
                  color: hexColorTextBlack.withOpacity(0.8),
                  letterSpacing: letterSpacingSmall,
                  fontSize: textfontSizeNote,
                ),
              ),
            ],
          ),

          titlePadding: const EdgeInsets.all(spacingMedium),
          contentPadding: const EdgeInsets.only(
            right: spacingMedium,
            left: spacingMedium,
            bottom: spacingMedium,
          ),
          buttonPadding: const EdgeInsets.all(spacingMedium),
          content: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RatingBar.builder(
                  minRating: 0,
                  maxRating: 5,
                  itemCount: 5,
                  allowHalfRating: true,
                  direction: Axis.horizontal,
                  wrapAlignment: WrapAlignment.spaceEvenly,
                  itemSize: 50,
                  itemBuilder: (context, index) =>
                      const Icon(Icons.star_rounded, color: colorIcon),
                  onRatingUpdate: (value) {
                    setState(() {
                      score = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.only(
            right: spacingMedium,
            left: spacingMedium,
            bottom: spacingMedium,
          ),
          actions: [
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(hexColorLogout),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: borderRadiusButton),
                  ),
                ),
                child: Text("HỦY", style: style),
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  try {
                    Get.back();

                    Get.dialog(
                      Center(child: circularProgress),
                      barrierDismissible: false,
                    );

                    final resultRatingMovie = await ref
                        .read(movieServiceProvider)
                        .ratingMovie(movie.idMovie!, score);

                    if (navigator.canPop()) {
                      navigator.pop();
                    }

                    if (!resultRatingMovie["success"]) {
                      showSnackbar(
                        title: "Đánh giá phim",
                        message: resultRatingMovie["message"],
                        type: "error",
                        func: () async {
                          if (resultRatingMovie.containsKey("typeError") &&
                              resultRatingMovie["typeError"] ==
                                  "Chưa được xác minh") {
                            NavigationHelper.goToLogin(
                              returnRoute: returnRoute,
                            );
                          }
                        },
                      );
                      return;
                    }

                    getMovieDate();
                    await ref.read(movieHotProvider.notifier).loadMoviesHot();

                    showSnackbar(
                      title: "Đánh giá phim",
                      message: resultRatingMovie["message"],
                      type: "success",
                    );
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
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(colorTextSuccess),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: borderRadiusButton),
                  ),
                ),

                child: Text("XÁC NHẬN", style: style),
              ),
            ),
          ],
        );
      },
    ),
  );

  onScoreChanged(0);
}
