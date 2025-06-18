import 'dart:io';

import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/login_screen.dart';
import 'package:ceni_fruit/model/user.dart';
import 'package:ceni_fruit/pages/info_account_page.dart';
import 'package:ceni_fruit/pages/booked_ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  File? _image;
  final picker = ImagePicker();
  User? currentUser = User.instance;

  pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _image = File(picked.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: bgColorApp,
        titleTextStyle: TextStyle(
          color: colorTextApp,
          fontSize: textfontSizeTitleAppBar,
        ),
      ),
      backgroundColor: bgColorApp,
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child:
                    _image == null
                        ? Icon(
                          Icons.person_rounded,
                          size: 80,
                          color: Colors.grey,
                        )
                        : null,
              ),
            ),
            SizedBox(height: 40),

            if (User.instance == null)
              ElevatedButton(
                style: ButtonStyle(
                  shadowColor: WidgetStateProperty.all(shadowColorBox),
                  elevation: WidgetStateProperty.all(9),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: Text(
                  "Đăng nhập",
                  style: TextStyle(fontSize: textfontSizeApp),
                ),
              )
            else ...[
              Align(
                alignment: Alignment.center,
                child: IntrinsicWidth(
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InfoAccountPage(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Row(
                            children: [
                              Text(
                                "Thông tin tài khoản",
                                style: TextStyle(
                                  fontSize: textfontSizeApp,
                                  fontFamily: fontApp,
                                  color: colorTextApp,
                                ),
                              ),
                              SizedBox(width: 15),
                              Icon(
                                Icons.edit_outlined,
                                size: iconfontSizeApp,
                                color: colorTextApp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 0.4,
                color: Colors.grey,
                indent: 60,
                endIndent: 60,
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BookedTicketPage()),
                    );
                  },
                  child: IntrinsicWidth(
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Lịch sử đặt vé",
                            style: TextStyle(
                              fontSize: textfontSizeApp,
                              fontFamily: fontApp,
                              color: colorTextApp,
                            ),
                          ),
                          SizedBox(width: 15),
                          Icon(
                            Icons.history_outlined,
                            size: iconfontSizeApp,
                            color: colorTextApp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Divider(
                thickness: 0.4,
                color: Colors.grey.shade400,
                indent: 60,
                endIndent: 60,
              ),

              Align(
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: IntrinsicWidth(
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Đăng xuất",
                            style: TextStyle(
                              fontSize: textfontSizeApp,
                              fontFamily: fontApp,
                              color: colorButton,
                            ),
                          ),
                          SizedBox(width: 15),
                          Icon(
                            Icons.logout_rounded,
                            size: iconfontSizeApp,
                            color: colorButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 0.4,
                color: Colors.grey.shade400,
                indent: 60,
                endIndent: 60,
              ),
            ],
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      spacing: 15,
                      children: [
                        Text(
                          "Liên hệ",
                          style: TextStyle(
                            fontSize: textfontSizeApp,
                            fontFamily: fontApp,
                            color: colorTextApp,
                          ),
                        ),
                        Icon(
                          Icons.contact_mail_outlined,
                          size: iconfontSizeApp,
                          color: colorTextApp,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "travfruit@gmail.com",
                  style: TextStyle(
                    fontSize: textfontSizeApp,
                    fontFamily: fontApp,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
