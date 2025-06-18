import 'package:ceni_fruit/config/styles.dart';
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

    Widget buildEmail() {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: colorTextApp,
          boxShadow: [
            BoxShadow(
              offset: Offset(3, 3),
              blurRadius: 6,
              color: Colors.grey.shade400,
            ),
          ],
        ),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your Email";
            }
          },
          controller: emailController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.email_outlined),
            hintText: "Enter your email",
          ),
        ),
      );
    }

    Widget buildPassword() {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: colorTextApp,
          boxShadow: [
            BoxShadow(
              offset: Offset(3, 3),
              blurRadius: 6,
              color: Colors.grey.shade400,
            ),
          ],
        ),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your password";
            }
          },
          controller: passwordController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.lock_outline_rounded),
            hintText: "Enter your password",
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                  Text(
                    "LOGIN",
                    style: TextStyle(
                      color: colorTextApp,
                      fontSize: textfontSizeTitleAppBar,
                      fontFamily: fontApp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 10,
                      shadows: [
                        Shadow(
                          color: Colors.purple,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  buildEmail(),
                  SizedBox(height: 25),
                  buildPassword(),
                  SizedBox(height: 50),
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
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(colorButton),
                      ),

                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: textfontSizeApp,
                          color: colorTextApp,
                          letterSpacing: 3,
                        ),
                      ),
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
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: textfontSizeNote,
                    fontWeight: FontWeight.w400,
                    color: colorTextApp,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignUpCreen()),
                    );
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: textfontSizeNote,
                      fontWeight: FontWeight.w400,
                      color: Color(0xfffca148),
                    ),
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
