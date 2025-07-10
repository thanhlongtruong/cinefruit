import 'dart:io';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:get/get.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/config/widget_not_loggedin.dart';
import 'package:ceni_fruit/model/user.dart';
import 'package:ceni_fruit/pages/info_account_page.dart';
import 'package:ceni_fruit/provider/user_handle_provider.dart';
import 'package:ceni_fruit/provider/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _image = File(picked.path);
      setState(() {});
    }
  }

  List<Widget> loggedined(User? user) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: spacingBig, bottom: 70),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacingBig,
          children: [
            GestureDetector(
              // onTap: pickImage,
              onTap: () {},
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(Icons.person_rounded, size: 80, color: Colors.grey)
                    : null,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacingMedium,
              children: [
                Text(
                  "${user?.name}",
                  style: TextStyle(
                    color: colorTextApp,
                    fontSize: textfontSizeTitleAppBar,
                    letterSpacing: letterSpacingSmall,
                    fontWeight: fontWeightSemiBold,
                  ),
                ),
                Text(
                  "${user?.email}",
                  style: TextStyle(
                    color: colorTextApp,
                    fontSize: textfontSizeNote,
                    letterSpacing: letterSpacingSmall,
                    fontWeight: fontWeightNormal,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InfoAccountPage(user: user),
                        ),
                      );
                    } else {
                      showSnackbar(
                        message: "Không thể truy cập thông tin cá nhân.",
                        title: "Tài khoản",
                        type: "error",
                      );
                    }
                  },
                  style: buttonStyle,
                  child: Row(
                    spacing: spacingSmall,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: iconfontSizeNormal,
                        color: colorTextApp,
                      ),
                      Text(
                        "Chỉnh sửa thông tin",
                        style: TextStyle(
                          color: colorTextApp,
                          fontSize: textfontSizeNote,
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightNormal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Align(
        child: InkWell(
          onTap: () async {
            Get.dialog(
              Center(child: circularProgress),
              barrierDismissible: false,
            );

            try {
              await ref.read(userHandleProvider.notifier).logout();

              if (Get.isDialogOpen == true) {
                Get.back();
              }

              showSnackbar(
                title: "Đăng xuất",
                message: "Đăng xuất thành công",
                type: "success",
              );
              setState(() {});
            } catch (error) {
              if (Get.isDialogOpen == true) {
                Get.back();
              }
              showSnackbar(
                message: "Đăng xuất không thành công",
                title: "Đăng xuất",
                type: "error",
              );
            }
          },
          child: IntrinsicWidth(
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: spacingMedium,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: iconfontSizeNormal,
                    color: Colors.amber,
                  ),
                  Text(
                    "Đăng xuất",
                    style: TextStyle(
                      fontSize: textfontSizeApp,
                      color: Colors.amber,
                      letterSpacing: letterSpacingSmall,
                      fontWeight: fontWeightSemiBold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfile);
    final background = ref.read(backgroundMovieHot.notifier).state;
    return userProfileState.when(
      data: (data) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Tài khoản", style: tilteStyleApp),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: bgColorApp,
        body: Stack(
          children: [
            if (background.isNotEmpty) ...backgroundApp(background),
            SafeArea(
              child: Column(
                mainAxisAlignment: userProfileState.value == null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  if (userProfileState.value != null)
                    ...loggedined(userProfileState.value)
                  else
                    notLoggedinYet(context),
                  Padding(
                    padding: const EdgeInsets.only(top: spacingBig),
                    child: Column(
                      spacing: spacingMedium,
                      children: [
                        Row(
                          spacing: spacingMedium,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Liên hệ",
                              style: TextStyle(
                                fontSize: textfontSizeApp,
                                color: colorTextApp,
                                letterSpacing: letterSpacingSmall,
                                fontWeight: fontWeightNormal,
                              ),
                            ),
                            const Icon(
                              Icons.email_outlined,
                              size: iconfontSizeNormal,
                              color: colorTextApp,
                            ),
                          ],
                        ),
                        const Text(
                          "travfruit@gmail.com",
                          style: TextStyle(
                            fontSize: textfontSizeApp,
                            fontWeight: fontWeightMedium,
                            letterSpacing: letterSpacingSmall,
                            color: hexColorInformationSpecial,
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
      ),
      error: (error, stackTrace) => buildErrorScreen(
        error,
        stackTrace,
        () => ref.read(userProfile.notifier).clearProfile(),
      ),
      loading: () => buildLoadingScreen(),
    );
  }
}
