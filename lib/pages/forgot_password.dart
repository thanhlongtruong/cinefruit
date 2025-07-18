import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/convert_time.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:ceni_fruit/provider/user_handle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ceni_fruit/Router/routers.dart';
import 'package:slide_countdown/slide_countdown.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  final String? email;
  final String? returnRoute;

  const ForgotPassword({super.key, this.email, this.returnRoute});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  Map<String, dynamic>? resCode = {};
  bool reSendCode = false;
  bool sendCode = false;

  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  List<TextEditingController> codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    for (var controller in codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> getCode() async {
    final navigator = Navigator.of(context);
    try {
      Get.dialog(Center(child: circularProgress), barrierDismissible: false);
      final result = await ref
          .read(userServiceProvider)
          .sendVerificationEmail(widget.email!);

      if (navigator.canPop()) {
        navigator.pop();
      }
      if (!result["success"]) {
        showSnackbar(
          message: result["message"],
          title: "Mã xác nhận",
          type: "error",
        );
        return;
      }
      setState(() {
        sendCode = true;
        resCode = result["data"]["emailVerification"] ?? {};
        reSendCode = false;
      });
      showSnackbar(
        message: result["message"],
        title: "Mã xác nhận",
        type: "success",
      );
    } catch (error) {
      if (navigator.canPop()) {
        navigator.pop();
      }
      showSnackbar(
        message: error.toString(),
        title: "Mã xác nhận",
        type: "success",
      );
    }
  }

  Future<void> confirmForgotPassowrd() async {
    final navigator = Navigator.of(context);
    try {
      String code = codeControllers.map((controller) => controller.text).join();
      if (code.length != 6) {
        showSnackbar(
          message: "Mã xác nhận gồm 6 số.",
          title: "Mã xác nhận",
          type: "error",
        );
      } else if (resCode?["code"] != null &&
          int.parse(code) != resCode?["code"]) {
        showSnackbar(
          message: "Mã xác nhận không chính xác.",
          title: "Mã xác nhận",
          type: "error",
        );
      } else {
        Object data = {
          "email": widget.email,
          "code_verify": int.parse(code),
          "newPassword": newPasswordController.text,
          "confirmPassword": confirmNewPasswordController.text,
        };
        Get.dialog(Center(child: circularProgress), barrierDismissible: false);

        final result = await ref.read(userServiceProvider).forgotPassword(data);

        if (navigator.canPop()) {
          navigator.pop();
        }
        if (!result["success"]) {
          showSnackbar(
            message: result["message"],
            title: "Mã xác nhận",
            type: "error",
          );
          return;
        }

        showSnackbar(
          message: result["message"],
          title: "Mật khẩu",
          type: "success",
        );

        switch (widget.returnRoute) {
          case Routers.login:
            {
              NavigationHelper.goBackToSpecificPage(Routers.login);

              break;
            }
          case Routers.inforUser:
            {
              NavigationHelper.goBackToSpecificPage(Routers.inforUser);
              break;
            }
          default:
            NavigationHelper.goToHomeAndRemove();
        }
        NavigationHelper.goToLogin(returnRoute: widget.returnRoute);
      }
    } catch (error) {
      if (navigator.canPop()) {
        navigator.pop();
      }
      showSnackbar(
        message: error.toString(),
        title: "Mã xác nhận",
        type: "success",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgApp = ref.read(backgroundMovieHot.notifier).state;
    final time = resCode != null
        ? convertTime(resCode!["expiredAt"] ?? "")
        : null;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        title: Text("Đặt lại mặt khẩu", style: tilteStyleApp),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: colorTextApp),
      ),
      body: Stack(
        children: [
          ...backgroundApp(bgApp),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(spacingMedium),
              child: Column(
                spacing: spacingBig,
                children: [
                  buildFeld(
                    "",
                    "Nhập mật khẩu mới",
                    newPasswordController,
                    Icon(Icons.lock_outline_rounded),
                    null,
                    "",
                    isPassword: true,
                  ),
                  buildFeld(
                    "",
                    "Nhập lại mật khẩu mới",
                    confirmNewPasswordController,
                    Icon(Icons.lock_outline_rounded),
                    null,
                    "",
                    isPassword: true,
                  ),
                  if (sendCode)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: spacingSmall,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            height: 50,
                            width: 50,
                            child: TextField(
                              controller: codeControllers[index],
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colorButton,
                                    width: 2,
                                  ),
                                ),
                              ),

                              style: TextStyle(
                                color: colorTextApp,
                                fontSize: textfontSizeApp,
                                fontWeight: fontWeightMedium,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  if (time != null && !reSendCode)
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: colorTextWarning,
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightMedium,
                          fontSize: textfontSizeApp,
                        ),
                        children: [
                          const TextSpan(text: "Gửi lại sau"),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: SlideCountdown(
                              key: ValueKey(resCode!["expiredAt"]),
                              slideDirection: SlideDirection.up,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              duration: Duration(
                                hours: time["hours"] ?? 0,
                                minutes: time["minutes"]!,
                                seconds: time["seconds"]!,
                              ),
                              style: TextStyle(
                                color: colorTextApp,
                                letterSpacing: letterSpacingSmall,
                                fontWeight: fontWeightMedium,
                                fontSize: textfontSizeApp,
                              ),
                              onDone: () {
                                setState(() {
                                  resCode = {};
                                  reSendCode = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (reSendCode)
                    GestureDetector(
                      onTap: () async => await getCode(),
                      child: Text(
                        "Gửi lại",
                        style: TextStyle(
                          color: colorTextWarning,
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightMedium,
                          fontSize: textfontSizeApp,
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (newPasswordController.text.isEmpty ||
                            confirmNewPasswordController.text.isEmpty) {
                          showSnackbar(
                            message: "Mật khẩu không được để trống.",
                            title: "Mật khẩu",
                            type: "error",
                          );
                        } else if (newPasswordController.text !=
                            confirmNewPasswordController.text) {
                          showSnackbar(
                            message:
                                "Mật khẩu mới và Nhập lại mật khẩu mới phải trùng nhau.",
                            title: "Mật khẩu",
                            type: "error",
                          );
                        } else {
                          if (!sendCode) {
                            await getCode();
                          } else {
                            confirmForgotPassowrd();
                          }
                        }
                      },
                      style: buttonStyle,

                      child: Text(
                        !sendCode ? "Lấy mã xác thực" : "Xác nhận",
                        style: textStyleElevatedButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
