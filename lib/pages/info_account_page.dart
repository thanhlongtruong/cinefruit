import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/model/user.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:ceni_fruit/provider/user_handle_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class InfoAccountPage extends ConsumerStatefulWidget {
  final User? user;
  const InfoAccountPage({super.key, required this.user});

  @override
  ConsumerState<InfoAccountPage> createState() => _InfoAccountPageState();
}

class _InfoAccountPageState extends ConsumerState<InfoAccountPage> {
  @override
  void initState() {
    super.initState();
    nameController.text = widget.user?.name ?? "";
    emailController.text = widget.user?.email ?? "";
    birthdayController.text = widget.user?.birthday ?? "";
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
  var birthdayController = TextEditingController();
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();
  bool updatePassword = false;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Đổi mật khẩu",
          style: TextStyle(
            color: colorTextApp,
            letterSpacing: letterSpacingSmall,
            fontSize: textfontSizeApp,
            fontWeight: fontWeightMedium,
          ),
        ),
        CupertinoSwitch(
          value: updatePassword,
          onChanged: (value) => setState(() {
            updatePassword = value;
          }),
        ),
      ],
    );
  }

  Widget buildButtonUpdateInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: spacingLarge),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: () async {
            Get.dialog(
              Center(child: circularProgress),
              barrierDismissible: false,
            );

            final name = nameController.text;
            final currentPassword = currentPasswordController.text;
            final newPassword = newPasswordController.text;
            final confirmNewPassword = confirmNewPasswordController.text;
            try {
              Map<String, dynamic> data = {
                "name": name,
                "password": currentPassword,
                "newPassword": newPassword,
                "confirmNewPassword": confirmNewPassword,
                "updatePassword": updatePassword,
              };

              final result = await ref
                  .read(userHandleProvider.notifier)
                  .update(data);

              if (Get.isDialogOpen == true) {
                Get.back();
              }
              if (result["statusCode"] == 200) {
                showSnackbar(
                  title: "Cập nhật thông tin",
                  message:
                      result["message"] ?? "Cập nhật thông tin thành công.",
                  type: "success",
                );
              } else {
                showSnackbar(
                  type: "error",
                  title: "Cập nhật thông tin",
                  message: result["message"] ?? "Cập nhật thông tin thất bại!",
                );
              }
            } catch (error) {
              if (Get.isDialogOpen == true) {
                Get.back();
              }
              showSnackbar(
                title: "Lỗi hệ thống",
                message: "Có lỗi xảy ra khi cập nhật thông tin: $error",
                type: "error",
              );
            }
          },
          child: Text(
            "Cập nhật",
            style: TextStyle(fontSize: textfontSizeApp, color: colorTextApp),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final background = ref.read(backgroundMovieHot.notifier).state;

    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: colorTextApp),
        title: Text("Chỉnh sửa thông tin", style: tilteStyleApp),
      ),
      backgroundColor: bgColorApp,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (background.isNotEmpty) ...backgroundApp(background),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                right: spacingMedium,
                left: spacingMedium,
                bottom: isKeyboardVisible ? bottomInset : 0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildFeld(
                      "",
                      "Nhập họ tên",
                      nameController,
                      Icon(Icons.person),
                      null,
                      "",
                    ),
                    SizedBox(height: spacingBig),
                    buildFeld(
                      "",
                      "Nhập email",
                      emailController,
                      Icon(Icons.email_outlined),
                      null,
                      "update",
                    ),
                    SizedBox(height: spacingBig),
                    buildFeld(
                      "date",
                      "Nhập ngày sinh",
                      birthdayController,
                      Icon(Icons.calendar_month_outlined),
                      null,
                      "update",
                    ),
                    SizedBox(height: spacingBig),
                    buildButtonUpdatePassword(),
                    if (updatePassword) ...[
                      SizedBox(height: spacingBig),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: spacingMedium,
                        children: [
                          buildFeld(
                            "",
                            "Nhập mật khẩu hiện tại",
                            currentPasswordController,
                            Icon(Icons.lock_outline_rounded),
                            null,
                            "",
                          ),
                          Text(
                            "Quên mật khẩu",
                            style: TextStyle(
                              color: hexColorLogout,
                              fontSize: textfontSizeApp,
                              letterSpacing: letterSpacingSmall,
                              fontWeight: fontWeightSemiBold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacingBig),
                      buildFeld(
                        "",
                        "Nhập mật khẩu mới",
                        newPasswordController,
                        Icon(Icons.lock_outline_rounded),
                        null,
                        "",
                      ),
                      SizedBox(height: spacingBig),
                      buildFeld(
                        "",
                        "Nhập lại mật khẩu mới",
                        confirmNewPasswordController,
                        Icon(Icons.lock_outline_rounded),
                        null,
                        "",
                      ),
                    ],
                    buildButtonUpdateInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
