import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/styles.dart';
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
  required detailCinemaState,
  required Function(double) onScoreChanged,
  required VoidCallback getMovieDate,
}) async {
  double score = 0;

  await Get.dialog(
    StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.white,

          insetPadding: EdgeInsets.all(spacingMedium),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusCardSmall),

          title: Text(
            "${detailCinemaState.movie.name}",
            style: TextStyle(
              fontWeight: fontWeightSemiBold,
              color: hexColorTextBlack,
              letterSpacing: letterSpacingSmall,
              fontSize: textfontSizeTitleAppBar,
            ),
          ),

          titlePadding: const EdgeInsets.all(spacingMedium),
          contentPadding: const EdgeInsets.only(
            right: spacingMedium,
            left: spacingMedium,
            bottom: spacingMedium,
          ),
          buttonPadding: const EdgeInsets.all(spacingMedium),
          content: RatingBar.builder(
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
                  try {
                    Get.back();

                    Get.dialog(
                      Center(child: circularProgress),
                      barrierDismissible: false,
                    );

                    final movieRoom = detailCinemaState.movieRooms.firstWhere(
                      (mr) => mr.idMovie == detailCinemaState.movie.idMovie,
                    );
                    final resultRatingMovie = await ref
                        .read(movieServiceProvider)
                        .ratingMovie(movieRoom.idMovieRoom!, score);

                    if (Get.isDialogOpen == true) {
                      Get.back();
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
                              returnRoute: '/detail_cinema',
                            );
                          }
                        },
                      );
                      return;
                    }
                    getMovieDate();
                    showSnackbar(
                      title: "Đánh giá phim",
                      message: resultRatingMovie["message"],
                      type: "success",
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
