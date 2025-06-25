import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/path_images.dart';
import 'package:ceni_fruit/home_creen.dart';
import 'package:ceni_fruit/sign_up_creen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 93,
            right: -122,
            child: Transform.rotate(
              angle: -20 * 3.141592653589793 / 180,
              child: Image.asset(
                cinefruit,
                width: 500,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),

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
            top: 230,
            left: 30,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ĐĂNG NHẬP", style: styleTopic),
                  const SizedBox(height: spacingLarge),
                  buildFeld(
                    "Nhập email",
                    emailController,
                    Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: spacingBig),
                  buildFeld(
                    "Nhập mật khẩu",
                    passwordController,
                    Icon(Icons.lock_outline_rounded),
                  ),
                  const SizedBox(height: spacingLarge),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomeCreen()),
                          (route) => false,
                        );
                      },
                      style: buttonStyle,

                      child: Text("Đăng nhập", style: textStyleElevatedButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width,
            child: Row(
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
