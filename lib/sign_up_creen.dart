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

  Widget buildEmail() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
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
          return null;
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
        color: Colors.white,
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
          return null;
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

  Widget buildConfirm() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
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
          return null;
        },
        controller: confirmPasswordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(Icons.lock_outline_rounded),
          hintText: "Enter your password",
        ),
      ),
    );
  }

  Widget buildName() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
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
            return "Enter your name";
          }
          return null;
        },
        controller: nameController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(Icons.person),
          hintText: "Enter your name",
        ),
      ),
    );
  }

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
            top: 230,
            left: 30,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50),
                  buildName(),
                  SizedBox(height: 25),
                  buildEmail(),
                  SizedBox(height: 25),
                  buildPassword(),
                  SizedBox(height: 25),
                  buildConfirm(),
                  SizedBox(height: 50),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 130,
                      height: 50,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [Color(0xfff7b858), Color(0xfffca148)],
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
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
                  "Already have account? ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 16,
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
