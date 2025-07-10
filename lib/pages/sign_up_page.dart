import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/path_images.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/pages/login_page.dart';
import 'package:ceni_fruit/provider/user_handle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class SignUpCreen extends ConsumerStatefulWidget {
  const SignUpCreen({super.key});

  @override
  ConsumerState<SignUpCreen> createState() => _SignUpCreenState();
}

class _SignUpCreenState extends ConsumerState<SignUpCreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var nameController = TextEditingController();
  var birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 20,
            left: -367,
            child: Transform.rotate(
              angle: -60 * 3.141592653589793 / 180,
              child: Image.asset(
                logoCinema,
                width: 1200,
                height: 880,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: isKeyboardVisible ? 50 : 150,
              right: spacingMedium,
              left: spacingMedium,
              bottom: isKeyboardVisible ? bottomInset : 0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ĐĂNG KÍ", style: styleTopic),
                        const SizedBox(height: spacingLarge),
                        buildFeld(
                          "",
                          "Nhập họ tên",
                          nameController,
                          Icon(Icons.person),
                          null,
                          "",
                        ),
                        const SizedBox(height: spacingBig),
                        buildFeld(
                          "date",
                          "Nhập ngày sinh",
                          birthdayController,
                          Icon(Icons.calendar_month_outlined),
                          context,
                          "",
                        ),
                        const SizedBox(height: spacingBig),
                        buildFeld(
                          "",
                          "Nhập email",
                          emailController,
                          Icon(Icons.email_outlined),
                          null,
                          "",
                        ),
                        const SizedBox(height: spacingBig),
                        buildFeld(
                          "",
                          "Nhập mật khẩu",
                          passwordController,
                          Icon(Icons.lock_outline_rounded),
                          null,
                          "",
                        ),
                        const SizedBox(height: spacingBig),
                        buildFeld(
                          "",
                          "Nhập lại mật khẩu",
                          confirmPasswordController,
                          Icon(Icons.lock_outline_rounded),
                          null,
                          "",
                        ),

                        const SizedBox(height: spacingLarge),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              final name = nameController.text;
                              final birthday = birthdayController.text;
                              final email = emailController.text;
                              final password = passwordController.text;
                              final passwordConfirm =
                                  confirmPasswordController.text;

                              Get.dialog(
                                Center(child: circularProgress),
                                barrierDismissible: false,
                              );

                              Map<String, dynamic> data = {
                                "name": name,
                                "birthday": birthday,
                                "email": email,
                                "password": password,
                                "passwordConfirm": passwordConfirm,
                              };

                              final userService = ref.read(userServiceProvider);
                              final result = await userService.register(data);

                              if (Get.isDialogOpen == true) {
                                Get.back();
                              }

                              if (result["statusCode"] == 200) {
                                showSnackbar(
                                  title: "Đăng kí",
                                  message:
                                      result["message"] ??
                                      "Đăng ký thành công.",
                                  type: "success",
                                );
                              } else {
                                showSnackbar(
                                  type: "error",
                                  title: "Đăng kí",
                                  message:
                                      result["message"] ?? "Đăng ký thất bại!",
                                );
                              }
                            },
                            style: buttonStyle,
                            child: Text(
                              "Đăng kí",
                              style: textStyleElevatedButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: spacingBig),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: spacingMedium,
                    children: [
                      Text(
                        "Bạn đã có tài khoản? ",
                        style: textNoteBottomStyle(colorTextApp),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        },
                        child: Text(
                          "Đăng nhập",
                          style: textNoteBottomStyle(Color(0xfffca148)),
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
    );
  }
}
