import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/provider/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderFoodDrink extends ConsumerStatefulWidget {
  const OrderFoodDrink({super.key});

  @override
  ConsumerState<OrderFoodDrink> createState() => _OrderFoodDrinkState();
}

class _OrderFoodDrinkState extends ConsumerState<OrderFoodDrink> {
  int currentSegment = 0;

  Map<int, Widget> slidingSegments = <int, Widget>{
    0: Text(
      "Combo",
      style: TextStyle(
        fontSize: textfontSizeApp,
        fontWeight: fontWeightSemiBold,
        letterSpacing: letterSpacingSmall,
      ),
    ),
    1: Text(
      "Bắp",
      style: TextStyle(
        fontSize: textfontSizeApp,
        fontWeight: fontWeightSemiBold,
        letterSpacing: letterSpacingSmall,
      ),
    ),
    2: Text(
      "Giải khát",
      style: TextStyle(
        fontSize: textfontSizeApp,
        fontWeight: fontWeightSemiBold,
        letterSpacing: letterSpacingSmall,
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
  }

  List combos = [
    {
      "id": "01",
      "title": "Combo1",
      "name": "1 bắp nguyên vị",
      "price": "200.000 VND",
    },
    {
      "id": "02",
      "title": "Combo2",
      "name": "1 bắp nguyên vị",
      "price": "200.000 VND",
    },
    {
      "id": "03",
      "title": "Combo3",
      "name": "1 bắp nguyên vị",
      "price": "200.000 VND",
    },
  ];

  List selectedCombos = [];

  void funcSelectedCombos({required String id, required String type}) {
    final combo = combos.where((cb) => cb["id"] == id);
    if (type == "increase") {
      selectedCombos.add(combo);
    } else if (type == "decrease") {
      selectedCombos.remove(combo);
    }
  }

  // String getQuantity(String id){

  // }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: colorTextApp),
      title: Text(
        "Chọn thức ăn và đồ uống",
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

  Widget buildCombo() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(combos.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: spacingBig),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacingMedium,
              children: [
                ClipRRect(
                  borderRadius: borderRadiusButton,
                  child: CachedNetworkImage(
                    imageUrl: "",
                    width: 150,
                    height: 150,
                    errorWidget:
                        (context, url, error) => Container(
                          width: 150,
                          height: 150,
                          color: Colors.black,
                        ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        combos[index]["title"],
                        style: TextStyle(
                          fontSize: textfontSizeApp,
                          fontWeight: fontWeightMedium,
                          color: colorTextApp,
                          letterSpacing: letterSpacingSmall,
                        ),
                      ),
                      SizedBox(height: spacingSmall),
                      Text(
                        combos[index]["name"],
                        style: TextStyle(
                          fontSize: textfontSizeNote,
                          color: Colors.white,
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightNormal,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                      SizedBox(height: spacingSmall),
                      Text(
                        combos[index]["price"],
                        style: TextStyle(
                          fontSize: textfontSizeNote,
                          color: Colors.white,
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightNormal,
                        ),
                      ),
                      SizedBox(height: spacingMedium),

                      Row(
                        spacing: spacingMedium,
                        children: [
                          buildButton(
                            Icon(Icons.remove, color: Colors.white, size: 19),
                            combos[index]["id"],
                            "decrease",
                          ),
                          Text(
                            "${selectedCombos.remove(combos)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: textfontSizeApp,
                              fontWeight: fontWeightMedium,
                              letterSpacing: letterSpacingSmall,
                            ),
                          ),
                          buildButton(
                            Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                            combos[index]["id"],
                            "increase",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildPopcorn() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacingBig,
        mainAxisSpacing: spacingBig,
        mainAxisExtent: 270,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(spacingSmall),
          decoration: BoxDecoration(
            borderRadius: borderRadiusButton,
            border: Border.all(width: 1, color: (Color(0xfffca148))),
          ),
          child: Column(
            spacing: spacingSmall,
            children: [
              Text(
                '60.000 VND',
                style: TextStyle(
                  fontSize: textfontSizeNote,
                  fontWeight: fontWeightMedium,
                  letterSpacing: letterSpacingSmall,
                  color: colorTextApp,
                ),
              ),
              ClipRRect(
                borderRadius: borderRadiusButton,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://popcornandcandyfloss.com/cdn/shop/files/Studio_Session-164-2_1.jpg?v=1693889555&width=2048",
                  width: 150,
                  height: 150,
                  errorWidget:
                      (context, url, error) => Container(
                        width: 150,
                        height: 150,
                        color: Colors.black,
                      ),
                ),
              ),
              Text(
                'Bắp rang bơ phô mai',
                style: TextStyle(
                  fontSize: textfontSizeSmall,
                  fontWeight: fontWeightMedium,
                  letterSpacing: letterSpacingSmall,
                  color: colorTextApp,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: spacingMedium,
                children: [
                  buildButton(
                    Icon(Icons.remove, color: Colors.white, size: 19),
                    combos[index]["id"],
                    "decrease",
                  ),
                  const Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textfontSizeApp,
                      fontWeight: fontWeightMedium,
                      letterSpacing: letterSpacingSmall,
                    ),
                  ),
                  buildButton(
                    Icon(Icons.add_rounded, color: Colors.white, size: 19),
                    combos[index]["id"],
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

  Widget buildDrink() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacingBig,
        mainAxisSpacing: spacingBig,
        mainAxisExtent: 270,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(spacingSmall),
          decoration: BoxDecoration(
            borderRadius: borderRadiusButton,
            border: Border.all(width: 1, color: (Color(0xfffca148))),
          ),
          child: Column(
            spacing: spacingSmall,
            children: [
              Text(
                '30.000 VND',
                style: TextStyle(
                  fontSize: textfontSizeNote,
                  fontWeight: fontWeightMedium,
                  letterSpacing: letterSpacingSmall,
                  color: colorTextApp,
                ),
              ),
              ClipRRect(
                borderRadius: borderRadiusButton,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://media.istockphoto.com/id/508707347/vi/anh/coca-cola-v%E1%BB%9Bi-%C4%91%C3%A1-vi%C3%AAn-trong-c%E1%BB%91c-nguy%C3%AAn-b%E1%BA%A3n.jpg?s=612x612&w=0&k=20&c=Tf95WrkuwXX-QjkHt3cODJV5M6MitppxaiD4bvoHzV0=",
                  width: 150,
                  height: 150,
                  errorWidget:
                      (context, url, error) => Container(
                        width: 150,
                        height: 150,
                        color: Colors.black,
                      ),
                ),
              ),
              Text(
                'Coca Cola',
                style: TextStyle(
                  fontSize: textfontSizeSmall,
                  fontWeight: fontWeightMedium,
                  letterSpacing: letterSpacingSmall,
                  color: colorTextApp,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: spacingMedium,
                children: [
                  buildButton(
                    Icon(Icons.remove, color: Colors.white, size: 19),
                    combos[index]["id"],
                    "decrease",
                  ),
                  const Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textfontSizeApp,
                      fontWeight: fontWeightMedium,
                      letterSpacing: letterSpacingSmall,
                    ),
                  ),
                  buildButton(
                    Icon(Icons.add_rounded, color: Colors.white, size: 19),
                    combos[index]["id"],
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

  Widget buildGiaTien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacingMedium,
          children: [
            Text(
              'Tiền vé: 95.000 VND',
              style: TextStyle(
                fontSize: textfontSizeApp,
                fontWeight: fontWeightNormal,
                letterSpacing: letterSpacingSmall,
                color: Colors.white,
              ),
            ),
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
                    text: '95.000 VND',
                    style: TextStyle(
                      fontSize: textfontSizeApp,
                      fontWeight: fontWeightHeavy,
                      letterSpacing: letterSpacingSmall,
                      color: (Color(0xfffca148)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: buttonStyle,

          child: Text("Tiếp tục", style: textStyleElevatedButton),
        ),
      ],
    );
  }

  Widget buildButton(Widget caculate, String id, String type) {
    return GestureDetector(
      onTap: () {
        funcSelectedCombos(id: id, type: type);
        setState(() {});
      },
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 2, color: Colors.white),
          borderRadius: borderRadiusButton,
        ),
        child: caculate,
      ),
    );
  }

  Widget buildSegmentContent() {
    switch (currentSegment) {
      case 0:
        return buildCombo();
      case 1:
        return buildPopcorn();
      case 2:
        return buildDrink();
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieHot = ref.read(movieHotProvider.notifier);
    final bgApp = ref.read(backgroundAppProvider.notifier).state;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(),
      body: Stack(
        children: [
          if (bgApp.isNotEmpty) ...backgroundApp(bgApp),
          Padding(
            padding: const EdgeInsets.only(
              top: 120,
              right: spacingMedium,
              left: spacingMedium,
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
                Expanded(child: buildSegmentContent()),
                SizedBox(height: 150, child: buildGiaTien()),
              ],
            ),
          ),
        ],
      ),

      // body: Container(color: Colors.black),
    );
  }
}
