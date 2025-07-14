import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/pages/verify_email_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/path_images.dart';
import 'package:ceni_fruit/home_creen.dart';
import 'package:ceni_fruit/pages/sign_up_page.dart';
import 'package:ceni_fruit/provider/user_handle_provider.dart';
import 'package:get/get.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            bottom: -107,
            left: -207,
            child: Transform.rotate(
              angle: 37 * 3.141592653589793 / 180,
              child: Image.asset(
                logoCinema,
                width: 830,
                height: 640,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            top: -140,
            right: -170,
            child: Transform.rotate(
              angle: 25 * 3.141592653589793 / 180,
              child: Image.asset(
                logoCinema,
                width: 700,
                height: 540,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 230,
              right: spacingMedium,
              left: spacingMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: spacingMedium,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomeCreen()),
                        (route) => false,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: colorTextApp,
                        size: iconfontSizeNormal,
                      ),
                    ),
                    Text("ĐĂNG NHẬP", style: styleTopic),
                  ],
                ),
                const SizedBox(height: spacingLarge),
                buildFeld(
                  "",
                  "Nhập email",
                  emailController,
                  Icon(Icons.email_outlined),
                  null,
                  "",
                ),
                const SizedBox(height: spacingBig),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: spacingMedium,
                  children: [
                    buildFeld(
                      "",
                      "Nhập mật khẩu",
                      passwordController,
                      Icon(Icons.lock_outline_rounded),
                      null,
                      "",
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Quên mật khẩu",
                        style: TextStyle(
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightMedium,
                          color: Colors.red,
                          fontSize: textfontSizeNote,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacingLarge),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = emailController.text;
                      final password = passwordController.text;

                      final navigator = Navigator.of(context);
                      try {
                        Get.dialog(
                          Center(child: circularProgress),
                          barrierDismissible: false,
                        );
                        final dataLogin = await ref
                            .read(userHandleProvider.notifier)
                            .login(email, password);

                        if (Get.isDialogOpen == true) {
                          Get.back();
                        }

                        if (dataLogin["statusCode"] != null &&
                            dataLogin["statusCode"] == 200) {
                          if (dataLogin["data"]["user"]["verification"] ==
                              false) {
                            await ref
                                .read(userHandleProvider.notifier)
                                .logout();
                            navigator.push(
                              MaterialPageRoute(
                                builder: (_) => VerifyEmailPage(
                                  email: dataLogin["data"]["user"]["email"],
                                ),
                              ),
                            );
                          } else {
                            showSnackbar(
                              message: dataLogin["message"],
                              title: "Đăng nhập",
                              type: "success",
                            );

                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => HomeCreen()),
                              (route) => false,
                            );
                          }
                        } else {
                          if (Get.isDialogOpen == true) {
                            Get.back();
                          }

                          showSnackbar(
                            message: dataLogin["message"],
                            title: "Đăng nhập",
                            type: "error",
                          );
                        }
                      } catch (e) {
                        if (Get.isDialogOpen == true) {
                          Get.back();
                        }

                        showSnackbar(
                          title: "Lỗi hệ thống",
                          message: "Có lỗi xảy ra khi đăng nhập: $e",
                          type: "error",
                        );
                      }
                    },
                    style: buttonStyle,

                    child: Text("Đăng nhập", style: textStyleElevatedButton),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: spacingBig,
            width: MediaQuery.of(context).size.width,
            child: Row(
              spacing: spacingMedium,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bạn chưa có tài khoản? ",
                  style: textNoteBottomStyle(colorTextApp),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignUpCreen()),
                    );
                  },
                  child: Text(
                    "Đăng kí",
                    style: textNoteBottomStyle(Color(0xfffca148)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
