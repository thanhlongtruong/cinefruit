import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/model/user.dart';
import 'package:flutter/material.dart';

class InfoAccountPage extends StatefulWidget {
  const InfoAccountPage({super.key});

  @override
  State<InfoAccountPage> createState() => _InfoAccountPageState();
}

class _InfoAccountPageState extends State<InfoAccountPage> {
  // User? currentUser = User.instance;

  @override
  void initState() {
    super.initState();
    // nameController.text = User.instance?.name ?? "";
    // emailController.text = User.instance?.email ?? "";
    nameController.addListener(_onTextChanged);
    emailController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    nameController.removeListener(_onTextChanged);
    emailController.removeListener(_onTextChanged);
    nameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();
  bool updatePassword = false;

  Widget buildName() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: borderRadiusCardSmall,
        color: colorTextApp,
        boxShadow: [
          BoxShadow(offset: Offset(3, 3), blurRadius: 6, color: shadowColorBox),
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

  Widget buildEmail() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: borderRadiusCardSmall,
        color: colorTextApp,
        boxShadow: [
          BoxShadow(offset: Offset(3, 3), blurRadius: 6, color: shadowColorBox),
        ],
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter your email";
          }
          return null;
        },
        controller: emailController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your email",
          prefixIcon: Icon(Icons.email_outlined),
          contentPadding: EdgeInsets.only(top: 14),
        ),
      ),
    );
  }

  Widget buildOldPassword() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: borderRadiusCardSmall,
        color: colorTextApp,
        boxShadow: [
          BoxShadow(offset: Offset(3, 3), blurRadius: 6, color: shadowColorBox),
        ],
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter your current password";
          }
          return null;
        },
        controller: currentPasswordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your current password",
          prefixIcon: Icon(Icons.password_rounded),
          contentPadding: EdgeInsets.only(top: 14),
        ),
      ),
    );
  }

  Widget buildNewPassword() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: borderRadiusCardSmall,
        color: colorTextApp,
        boxShadow: [
          BoxShadow(offset: Offset(3, 3), blurRadius: 6, color: shadowColorBox),
        ],
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter your new password";
          }
          return null;
        },
        controller: newPasswordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your new password",
          prefixIcon: Icon(Icons.password_rounded),
          contentPadding: EdgeInsets.only(top: 14),
        ),
      ),
    );
  }

  Widget buildConfirmNewPassword() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: borderRadiusCardSmall,
        color: colorTextApp,
        boxShadow: [
          BoxShadow(offset: Offset(3, 3), blurRadius: 6, color: shadowColorBox),
        ],
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Re-enter new password";
          }
          return null;
        },
        controller: confirmNewPasswordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Re-enter new password",
          prefixIcon: Icon(Icons.password_rounded),
          contentPadding: EdgeInsets.only(top: 14),
        ),
      ),
    );
  }

  Widget buildButtonUpdatePassword() {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        onPressed:
            () => {
              setState(() {
                updatePassword = !updatePassword;
              }),
            },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(colorTextApp),
        ),
        child: Text(
          "Udate password",
          style: TextStyle(fontSize: textfontSizeApp),
        ),
      ),
    );
  }

  Widget buildButtonUpdateInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          style: ButtonStyle(
            // backgroundColor: WidgetStatePropertyAll(
            //   currentUser?.email == emailController.text &&
            //           currentUser?.name == nameController.text
            //       ? colorTextApp.withOpacity(opacityColorApp)
            //       : colorButton,
            // ),
          ),
          onPressed: () => {},
          child: Text(
            "UPDATE",
            style: TextStyle(fontSize: textfontSizeApp, color: colorTextApp),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: bgColorApp,
        iconTheme: IconThemeData(color: colorTextApp),
        title: Text(
          "Cập nhật",
          style: TextStyle(
            color: colorTextApp,
            fontSize: textfontSizeTitleAppBar,
          ),
        ),
      ),
      backgroundColor: bgColorApp,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          child: Column(
            children: [
              buildName(),
              SizedBox(height: 20),
              buildEmail(),
              SizedBox(height: 20),
              buildButtonUpdatePassword(),
              if (updatePassword) ...[
                SizedBox(height: 20),
                buildOldPassword(),
                SizedBox(height: 20),
                buildNewPassword(),
                SizedBox(height: 20),
                buildConfirmNewPassword(),
              ],
              SizedBox(height: 20),
              Spacer(),
              buildButtonUpdateInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
