import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/convert_time.dart';
import 'package:ceni_fruit/config/path_images.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/pages/login_page.dart';
import 'package:ceni_fruit/provider/user_handle_provider.dart';
import 'package:flutter/material.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:slide_countdown/slide_countdown.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailPage({super.key, required this.email});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  Map<String, dynamic>? data = {};
  bool reSendCode = false;
  List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  Future<void> getCode() async {
    try {
      Get.dialog(Center(child: circularProgress), barrierDismissible: false);
      final result = await ref
          .read(userServiceProvider)
          .sendVerificationEmail(widget.email);

      if (Get.isDialogOpen == true) {
        Get.back();
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
        data = result["data"]["emailVerification"] ?? {};
        reSendCode = false;
      });
      showSnackbar(
        message: result["message"],
        title: "Mã xác nhận",
        type: "success",
      );
    } catch (error) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      showSnackbar(
        message: error.toString(),
        title: "Mã xác nhận",
        type: "success",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCode();
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = data != null? convertTime(data!["expiredAt"] ?? "") :null;
    return Scaffold(
      backgroundColor: bgColorApp,
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text("Xác minh email", style: tilteStyleApp),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(spacingMedium),
        child: Column(
          spacing: spacingBig,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(logoVerify),

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
                      controller: controllers[index],
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: borderRadiusButton,
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: borderRadiusButton,
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                      style: TextStyle(
                        color: colorButton,
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
                        key: ValueKey(data!["expiredAt"]),
                        slideDirection: SlideDirection.up,
                        decoration: BoxDecoration(color: Colors.transparent),
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
                            data = {};
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

            SizedBox(
              width: 330,
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: 'Chúng tôi đã gửi mã xác thực đến ',
                  style: TextStyle(
                    fontSize: textfontSizeApp,
                    fontWeight: fontWeightNormal,
                    letterSpacing: letterSpacingSmall,
                    color: colorTextApp,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.email,
                      style: TextStyle(
                        fontSize: textfontSizeApp,
                        fontWeight: fontWeightNormal,
                        letterSpacing: letterSpacingSmall,
                        color: hexColorInformationSpecial,
                      ),
                    ),
                    TextSpan(
                      text: ' .Hãy kiểm tra email của bạn.',
                      style: TextStyle(
                        fontSize: textfontSizeApp,
                        fontWeight: fontWeightNormal,
                        letterSpacing: letterSpacingSmall,
                        color: colorTextApp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: 260,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                
                  String code = controllers
                      .map((controller) => controller.text)
                      .join();
                  if (code.length != 6) {
                    showSnackbar(
                      message: "Mã xác nhận gồm 6 số.",
                      title: "Mã xác nhận",
                      type: "error",
                    );
                  } else if (data?["code"] != null && int.parse(code) != data?["code"]) {
                    showSnackbar(
                      message: "Mã xác nhận không chính xác.",
                      title: "Mã xác nhận",
                      type: "error",
                    );
                  } else {
                    try {
                      final navigator = Navigator.of(context);
                      Get.dialog(
                        Center(child: circularProgress),
                        barrierDismissible: false,
                      );
                      final result = await ref
                          .read(userServiceProvider)
                          .updateVerificationEmail(widget.email);

                      if (Get.isDialogOpen == true) {
                        Get.back();
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
                        title: "Mã xác nhận",
                        type: "success",
                      );
                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => LoginPage()),
                        (route) => false,
                      );
                    } catch (error) {
                      if (Get.isDialogOpen == true) {
                        Get.back();
                      }
                      showSnackbar(
                        message: error.toString(),
                        title: "Mã xác nhận",
                        type: "success",
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadiusButton,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Xác nhận",
                  style: TextStyle(
                    fontSize: textfontSizeApp,
                    fontWeight: fontWeightNormal,
                    letterSpacing: letterSpacingSmall,
                    color: colorTextApp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
