import 'dart:ui';

import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/catch_network_image.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/convert_time.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/model/food_drink.dart';
import 'package:ceni_fruit/model/holding_seat.dart';
import 'package:ceni_fruit/model/order_food_drink.dart';
import 'package:ceni_fruit/model/params_pay_page.dart';
import 'package:ceni_fruit/provider/food_drink_provider.dart';
import 'package:ceni_fruit/provider/payment_method_provider.dart';
import 'package:ceni_fruit/service/currency_exchange_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:slide_countdown/slide_countdown.dart';

class OrderFoodDrink extends ConsumerStatefulWidget {
  final ParamsOrderFoodDrink paramsOrderFoodDrink;

  const OrderFoodDrink({super.key, required this.paramsOrderFoodDrink});

  @override
  ConsumerState<OrderFoodDrink> createState() => _OrderFoodDrinkState();
}

class _OrderFoodDrinkState extends ConsumerState<OrderFoodDrink> {
  late HoldingSeat? seatUser;
  int currentSegment = 0;
  String newPrice = "";
  @override
  void initState() {
    super.initState();
    seatUser = widget.paramsOrderFoodDrink.seatUser;
    newPrice = widget.paramsOrderFoodDrink.price;
  }

  List<Map<String, dynamic>> groupAndCountFoodDrinks(
    List<FoodDrink> foodDrinks,
  ) {
    Map<String, Map<String, dynamic>> groupedMap = {};

    for (var food in foodDrinks) {
      String id = food.idFoodDrink!;
      if (!groupedMap.containsKey(id)) {
        groupedMap[id] = {'id': food, 'quantity': 1};
      } else {
        groupedMap[id]!['quantity']++;
      }
    }

    return groupedMap.values.toList();
  }

  List<FoodDrink> selectedCombos = [];
  List<FoodDrink> selectedPopcorns = [];
  List<FoodDrink> selectedDrinks = [];

  void funcSelectedFoodDrink({
    required FoodDrink foodDrink,
    required String type,
  }) {
    final typeFoodDrink = ["Combo", "Bắp", "Giải khát"];

    if (type == "increase") {
      if (!typeFoodDrink.contains(foodDrink.type)) {
        return;
      }
      if (foodDrink.type == "Combo") {
        selectedCombos.add(foodDrink);
      } else if (foodDrink.type == "Bắp") {
        selectedPopcorns.add(foodDrink);
      } else if (foodDrink.type == "Giải khát") {
        selectedDrinks.add(foodDrink);
      }

      newPrice = formatCurrencyVND(
        currencyVND(newPrice) + currencyVND(foodDrink.price!),
      );
    } else if (type == "decrease") {
      if (!typeFoodDrink.contains(foodDrink.type)) {
        return;
      }
      bool stateRemove = false;
      if (foodDrink.type == "Combo") {
        stateRemove = selectedCombos.remove(foodDrink);
      } else if (foodDrink.type == "Bắp") {
        stateRemove = selectedPopcorns.remove(foodDrink);
      } else if (foodDrink.type == "Giải khát") {
        stateRemove = selectedDrinks.remove(foodDrink);
      }

      if (stateRemove) {
        newPrice = formatCurrencyVND(
          currencyVND(newPrice) - currencyVND(foodDrink.price!),
        );
      }
    }
  }

  AppBar appBar() {
    final time = convertTime(seatUser?.expiredAt ?? "");
    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: colorTextApp),
      title: const Text(
        "Chọn thức ăn và đồ uống",
        style: tilteStyleApp,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: false,
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
                      onDone: () {
                        setState(() {
                          seatUser = null;
                        });
                        NavigationHelper.goBack();
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget buildCombo(List<FoodDrink> typeCombo) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(typeCombo.length, (index) {
          final countSelected = selectedCombos
              .where((sc) => sc.idFoodDrink == typeCombo[index].idFoodDrink)
              .length;

          return Padding(
            padding: const EdgeInsets.only(bottom: spacingBig),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacingMedium,
              children: [
                ClipRRect(
                  borderRadius: borderRadiusCardSmall,
                  child: cachedNetworkImageConfig(
                    typeCombo[index].urlImage!,
                    150,
                    150,
                    BoxFit.fill,
                    iconfontSizeNormal,
                  ),
                ),

                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      spacing: spacingMedium,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: spacingSmall,
                          children: [
                            Text(
                              "${typeCombo[index].name}",
                              style: const TextStyle(
                                fontSize: textfontSizeApp,
                                fontWeight: fontWeightMedium,
                                color: colorTextApp,
                                letterSpacing: letterSpacingSmall,
                              ),
                            ),
                            Text(
                              "${typeCombo[index].description}",
                              style: const TextStyle(
                                fontSize: textfontSizeNote,
                                color: colorTextApp,
                                letterSpacing: letterSpacingSmall,
                                fontWeight: fontWeightNormal,
                              ),
                            ),
                            Text(
                              "${typeCombo[index].price}",
                              style: const TextStyle(
                                fontSize: textfontSizeApp,
                                color: colorTextApp,
                                letterSpacing: letterSpacingSmall,
                                fontWeight: fontWeightNormal,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          spacing: spacingMedium,
                          children: [
                            buildButton(
                              const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 18,
                              ),
                              typeCombo[index],
                              "decrease",
                            ),

                            Text(
                              "$countSelected",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: textfontSizeApp,
                                fontWeight: fontWeightMedium,
                                letterSpacing: letterSpacingSmall,
                              ),
                            ),

                            buildButton(
                              const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              typeCombo[index],
                              "increase",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildPopcorn(List<FoodDrink> typePopcorn) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: typePopcorn.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacingMedium,
        mainAxisSpacing: spacingMedium,
        mainAxisExtent: 300,
      ),
      itemBuilder: (context, index) {
        final countSelected = selectedPopcorns
            .where((sc) => sc.idFoodDrink == typePopcorn[index].idFoodDrink)
            .length;
        return Container(
          padding: const EdgeInsets.all(spacingSmall),
          decoration: BoxDecoration(
            borderRadius: borderRadiusButton,
            border: Border.all(width: 1, color: colorButton),
          ),
          child: Column(
            spacing: spacingSmall,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${typePopcorn[index].price}",
                style: const TextStyle(
                  fontSize: textfontSizeNote,
                  fontWeight: fontWeightMedium,
                  letterSpacing: letterSpacingSmall,
                  color: colorTextApp,
                ),
              ),
              ClipRRect(
                borderRadius: borderRadiusCardSmall,
                child: cachedNetworkImageConfig(
                  typePopcorn[index].urlImage,
                  150,
                  150,
                  BoxFit.fill,
                  iconfontSizeNormal,
                ),
              ),
              Text(
                "${typePopcorn[index].name}",
                style: const TextStyle(
                  fontSize: textfontSizeNote,
                  fontWeight: fontWeightNormal,
                  letterSpacing: letterSpacingSmall,
                  color: colorTextApp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: spacingMedium,
                children: [
                  buildButton(
                    const Icon(Icons.remove, color: Colors.white, size: 18),
                    typePopcorn[index],
                    "decrease",
                  ),
                  Text(
                    "$countSelected",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: textfontSizeApp,
                      fontWeight: fontWeightMedium,
                      letterSpacing: letterSpacingSmall,
                    ),
                  ),
                  buildButton(
                    const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    typePopcorn[index],
                    "increase",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDrink(List<FoodDrink> typeDrink) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: typeDrink.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacingMedium,
        mainAxisSpacing: spacingMedium,
        mainAxisExtent: 280,
      ),
      itemBuilder: (context, index) {
        final countSelected = selectedDrinks
            .where((sc) => sc.idFoodDrink == typeDrink[index].idFoodDrink)
            .length;
        return Container(
          padding: const EdgeInsets.all(spacingSmall),
          decoration: BoxDecoration(
            borderRadius: borderRadiusButton,
            border: Border.all(width: 1, color: colorButton),
          ),
          child: Column(
            spacing: spacingSmall,
            children: [
              Text(
                "${typeDrink[index].price}",
                style: const TextStyle(
                  fontSize: textfontSizeNote,
                  fontWeight: fontWeightMedium,
                  letterSpacing: letterSpacingSmall,
                  color: colorTextApp,
                ),
              ),
              ClipRRect(
                borderRadius: borderRadiusCardSmall,
                child: cachedNetworkImageConfig(
                  typeDrink[index].urlImage,
                  150,
                  150,
                  BoxFit.fill,
                  iconfontSizeNormal,
                ),
              ),
              Text(
                "${typeDrink[index].name}",
                style: TextStyle(
                  fontSize: textfontSizeNote,
                  fontWeight: fontWeightNormal,
                  letterSpacing: letterSpacingSmall,
                  color: colorTextApp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: spacingMedium,
                children: [
                  buildButton(
                    const Icon(Icons.remove, color: Colors.white, size: 19),
                    typeDrink[index],
                    "decrease",
                  ),
                  Text(
                    "$countSelected",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: textfontSizeApp,
                      fontWeight: fontWeightMedium,
                      letterSpacing: letterSpacingSmall,
                    ),
                  ),
                  buildButton(
                    const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    typeDrink[index],
                    "increase",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildGiaTien(List<FoodDrink> foodDrinks) {
    var groupedFoods = groupAndCountFoodDrinks(selectedCombos);
    var groupedPopcorns = groupAndCountFoodDrinks(selectedPopcorns);
    var groupedDrinks = groupAndCountFoodDrinks(selectedDrinks);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: spacingSmall,
        children: [
          Text(
            "Tiền vé: ${widget.paramsOrderFoodDrink.price} x ${widget.paramsOrderFoodDrink.selectedSeats.length}",
            style: const TextStyle(
              fontSize: textfontSizeNote,
              fontWeight: fontWeightNormal,
              letterSpacing: letterSpacingSmall,
              color: colorTextApp,
            ),
          ),
          if (groupedFoods.isNotEmpty)
            Column(
              spacing: spacingSmall,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(groupedFoods.length, (index) {
                return Text(
                  "${(groupedFoods[index]["id"] as FoodDrink).name} - ${(groupedFoods[index]["id"] as FoodDrink).price} VND x ${groupedFoods[index]["quantity"]}",
                  style: const TextStyle(
                    fontSize: textfontSizeNote,
                    fontWeight: fontWeightNormal,
                    letterSpacing: letterSpacingSmall,
                    color: colorTextApp,
                  ),
                );
              }),
            ),
          if (groupedPopcorns.isNotEmpty)
            Column(
              spacing: spacingSmall,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(groupedPopcorns.length, (index) {
                return Text(
                  "${(groupedPopcorns[index]["id"] as FoodDrink).name} - ${(groupedPopcorns[index]["id"] as FoodDrink).price} VND x ${groupedPopcorns[index]["quantity"]}",
                  style: const TextStyle(
                    fontSize: textfontSizeNote,
                    fontWeight: fontWeightNormal,
                    letterSpacing: letterSpacingSmall,
                    color: colorTextApp,
                  ),
                );
              }),
            ),
          if (groupedDrinks.isNotEmpty)
            Column(
              spacing: spacingSmall,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(groupedDrinks.length, (index) {
                return Text(
                  "${(groupedDrinks[index]["id"] as FoodDrink).name} - ${(groupedDrinks[index]["id"] as FoodDrink).price} VND x ${groupedDrinks[index]["quantity"]}",
                  style: const TextStyle(
                    fontSize: textfontSizeNote,
                    fontWeight: fontWeightNormal,
                    letterSpacing: letterSpacingSmall,
                    color: colorTextApp,
                  ),
                );
              }),
            ),

          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Tổng: ',
                      style: TextStyle(
                        fontSize: textfontSizeApp,
                        fontWeight: fontWeightNormal,
                        letterSpacing: letterSpacingSmall,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: newPrice,
                          style: TextStyle(
                            fontSize: textfontSizeApp,
                            fontWeight: fontWeightMedium,
                            letterSpacing: letterSpacingSmall,
                            color: colorButton,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        if (seatUser == null) {
                          showSnackbar(
                            title: "Ghế",
                            message:
                                "Bạn đã hết thời gian giữ ghế. Vui lòng chọn lại ghế.",
                            type: "error",
                          );
                          NavigationHelper.goBack();
                        } else {
                          Get.dialog(
                            Center(child: circularProgress),
                            barrierDismissible: false,
                          );

                          final state = await ref
                              .read(paymentMethodNotifierProvider.notifier)
                              .loadPaymentMethod();

                          var groupedFoods = groupAndCountFoodDrinks(
                            selectedCombos,
                          );
                          var groupedPopcorns = groupAndCountFoodDrinks(
                            selectedPopcorns,
                          );
                          var groupedDrinks = groupAndCountFoodDrinks(
                            selectedDrinks,
                          );

                          List<Map<String, dynamic>> totalChooseFoodDrink = [
                            ...groupedFoods,
                            ...groupedPopcorns,
                            ...groupedDrinks,
                          ];

                          if (Get.isDialogOpen == true) {
                            Get.back();
                          }

                          ParamsPayPage params = ParamsPayPage(
                            selectedSeats:
                                widget.paramsOrderFoodDrink.selectedSeats,
                            selectedTime: widget.paramsOrderFoodDrink.time,
                            movie: widget.paramsOrderFoodDrink.movie,
                            price: newPrice,
                            cinema: widget.paramsOrderFoodDrink.cinema,
                            room: widget.paramsOrderFoodDrink.room,
                            paymentMethods: state,
                            movieRoom: widget.paramsOrderFoodDrink.movieRoom,
                            totalChooseFoodDrink: totalChooseFoodDrink,
                            seatUser: seatUser,
                          );

                          NavigationHelper.goToPay(params: params);
                        }
                      } catch (error) {
                        if (Get.isDialogOpen == true) {
                          Get.back();
                        }
                        showSnackbar(
                          title: "Lỗi hệ thống",
                          message: "$error.",
                          type: "error",
                        );
                      }
                    },
                    style: buttonStyle,

                    child: Text("Tiếp tục", style: textStyleElevatedButton),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(Widget caculate, FoodDrink foodDrink, String type) {
    return GestureDetector(
      onTap: () {
        funcSelectedFoodDrink(foodDrink: foodDrink, type: type);
        setState(() {});
      },
      child: Container(
        height: 27,
        width: 27,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 2, color: Colors.white),
          borderRadius: borderRadiusButton,
        ),
        child: caculate,
      ),
    );
  }

  Widget buildSegmentContent(List<FoodDrink> foodDrink) {
    final typeCombo = foodDrink.where((fr) => fr.type == "Combo").toList();
    final typePopcorn = foodDrink.where((fr) => fr.type == "Bắp").toList();
    final typeDrink = foodDrink.where((fr) => fr.type == "Giải khát").toList();
    switch (currentSegment) {
      case 0:
        return buildCombo(typeCombo);
      case 1:
        return buildPopcorn(typePopcorn);
      case 2:
        return buildDrink(typeDrink);
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Widget> slidingSegments = <int, Widget>{
      0: Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          "Combo",
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
          "Bắp",
          style: TextStyle(
            color: currentSegment == 1 ? hexColorTextBlack : colorTextApp,
            fontSize: textfontSizeApp,
            fontWeight: fontWeightMedium,
            letterSpacing: letterSpacingSmall,
          ),
        ),
      ),

      2: Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          "Giải khát",
          style: TextStyle(
            color: currentSegment == 2 ? hexColorTextBlack : colorTextApp,
            fontSize: textfontSizeApp,
            fontWeight: fontWeightMedium,
            letterSpacing: letterSpacingSmall,
          ),
        ),
      ),
    };

    final foodDrinkState = ref.watch(foodDrinkProvider);

    return foodDrinkState.when(
      data: (data) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar(),
        body: RefreshIndicator(
          onRefresh: () async =>
              await ref.read(foodDrinkProvider.notifier).refreshFoodDrink(),
          child: Stack(
            children: [
              ...backgroundApp(widget.paramsOrderFoodDrink.movie.urlImage!),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: spacingMedium,
                    left: spacingMedium,
                    top: spacingMedium,
                    bottom: 180,
                  ),
                  child: Column(
                    spacing: spacingMedium,
                    children: [
                      SizedBox(
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
                      Expanded(child: buildSegmentContent(data)),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ClipRRect(
                  borderRadius: borderRadiusCardSmall,
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    padding: const EdgeInsets.all(spacingMedium),
                    height: 200,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: buildGiaTien(data),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) => buildErrorScreen(error, stackTrace),
      loading: () => buildLoadingScreen(),
    );
  }
}
