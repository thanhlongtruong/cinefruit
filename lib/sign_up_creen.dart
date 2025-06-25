import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpCreen extends StatefulWidget {
  const SignUpCreen({super.key});

  @override
  State<SignUpCreen> createState() => _SignUpCreenState();
}

class _SignUpCreenState extends State<SignUpCreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var nameController = TextEditingController();
  var birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          Positioned(
            top: 93,
            right: -122,
            child: Transform.rotate(
              angle: -20 * 3.141592653589793 / 180,
              child: Image.asset(
                "assets/images/logo_cinefruit.png",
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
                "assets/images/logo.png",
                width: 830,
                height: 640,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            top: 180,
            left: 30,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ĐĂNG KÍ", style: styleTopic),
                  const SizedBox(height: spacingLarge),
                  buildFeld("Nhập họ tên", nameController, Icon(Icons.person)),
                  const SizedBox(height: spacingBig),
                  buildFeld(
                    "Nhập ngày sinh",
                    birthdayController,
                    Icon(Icons.person),
                  ),
                  const SizedBox(height: spacingBig),
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
                  const SizedBox(height: spacingBig),
                  buildFeld(
                    "Nhập lại mật khẩu",
                    confirmPasswordController,
                    Icon(Icons.lock_outline_rounded),
                  ),
                  const SizedBox(height: spacingLarge),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: buttonStyle,
                      child: Text("Đăng kí", style: textStyleElevatedButton),
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
                  "Bạn đã có tài khoản? ",
                  style: textNoteBottomStyle(colorTextApp),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
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
    );
  }
}
