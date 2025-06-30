import 'dart:ui';

import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:flutter/material.dart';
import 'package:ceni_fruit/config/styles.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          Positioned(
            top: 93,
            right: -122,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Transform.rotate(
                angle: -20 * 3.141592653589793 / 180,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 500,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -107,
            left: -207,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
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
          ),

          Positioned(
            top: 45,
            left: 60,
            child: Center(child: Image.asset("assets/images/verify.png")),
          ),

          Positioned(
            top: 320,
            left: 10,
            right: 5,
            child: Center(
              child: SizedBox(
                width: 450,
                child: Text(
                  'Nhập mã xác nhận của bạn',
                  style: TextStyle(
                    fontWeight: fontWeightTitleAppBar,
                    fontSize: 40,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),

                  softWrap: true,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: 450,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: spacingSmall,
                children: List.generate(6, (index) {
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: borderRadiusButton,
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: borderRadiusButton,
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            top: 530,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 330,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: 'Chúng tôi đã gửi mã xác thực đến email ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      letterSpacing: letterSpacingSmall,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'abc@gmail.com. ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          letterSpacing: letterSpacingSmall,
                          color: Color(0xfffca148), // màu cam
                        ),
                      ),
                      TextSpan(
                        text: 'Bạn hãy kiểm tra',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          letterSpacing: letterSpacingSmall,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 650,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 260, // đúng chiều rộng như ảnh
                height: 48, // chiều cao chuẩn nút
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF97142), // màu cam theo ảnh
                    shape: RoundedRectangleBorder(
                      borderRadius: borderRadiusButton, // bo góc lớn
                    ),
                    elevation: 0, // không đổ bóng
                  ),
                  child: Text(
                    "Xác nhận",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textfontSizeApp,
                      fontWeight: fontWeightSemiBold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
