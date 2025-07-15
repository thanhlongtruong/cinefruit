import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:intl/intl.dart';

const boxDecoration = BoxDecoration(
  color: colorTextApp,
  borderRadius: borderRadiusButton,
  boxShadow: [
    BoxShadow(offset: Offset(3, 3), blurRadius: 6, color: shadowColorBox),
  ],
);

const double height = 50;

const contentPadding = EdgeInsets.symmetric(vertical: 10);

const hintStyle = TextStyle(
  color: hexColorPlaceHolder,
  fontSize: textfontSizeApp,
  fontWeight: fontWeightSemiBold,
  letterSpacing: letterSpacingSmall,
);

final textStyle = TextStyle(
  color: Colors.black,
  letterSpacing: letterSpacingSmall,
  fontWeight: fontWeightSemiBold,
  fontSize: textfontSizeApp,
);

final styleTopic = TextStyle(
  color: colorTextApp,
  fontSize: textfontSizeTitleAppBar,
  fontWeight: fontWeightTitleAppBar,
  letterSpacing: letterSpacingMedium,
  shadows: [Shadow(color: Colors.purple, blurRadius: 20, offset: Offset(0, 8))],
);

const buttonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(colorButton),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: borderRadiusButton),
  ),
);

final textStyleElevatedButton = TextStyle(
  fontWeight: fontWeightSemiBold,
  fontSize: textfontSizeApp,
  color: colorTextApp,
  letterSpacing: letterSpacingSmall,
);

textNoteBottomStyle(Color color) {
  return TextStyle(
    fontSize: textfontSizeNote,
    fontWeight: fontWeightNormal,
    color: color,
    letterSpacing: letterSpacingSmall,
  );
}

Widget buildFeld(
  String? type,
  String title,
  TextEditingController controller,
  Icon icon,
  BuildContext? context,
  String? typeFunc,
) {
  return Container(
    height: height,
    decoration: boxDecoration,
    child: TextFormField(
      controller: controller,
      readOnly: typeFunc == "update" || type == "date",
      autofocus: false,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: contentPadding,
        prefixIcon: icon,
        hintText: title,
        hintStyle: hintStyle,
      ),
      onTap: () {
        if (type == "date" && context != null) {
          showDatePicker(context, controller);
        }

        if (typeFunc == "update") {
          showSnackbar(
            title: "Cập nhật",
            message: "Không thể thay đổi thông tin này",
            type: "error",
          );
          return;
        }
      },
      style: TextStyle(
        color: hexColorTextBlack,
        fontSize: textfontSizeApp,
        fontWeight: fontWeightMedium,
        letterSpacing: letterSpacingSmall,
      ),
    ),
  );
}

void showDatePicker(BuildContext context, TextEditingController controller) {
  BottomPicker.date(
    pickerTitle: Text(
      "Chọn ngày sinh",
      style: TextStyle(
        color: Colors.black,
        fontSize: textfontSizeTitleAppBar,
        fontWeight: fontWeightMedium,
        letterSpacing: letterSpacingSmall,
      ),
    ),
    buttonContent: Text(
      "Xác nhận",
      style: TextStyle(
        color: colorTextApp,
        fontSize: textfontSizeApp,
        fontWeight: fontWeightMedium,
        letterSpacing: letterSpacingSmall,
      ),
    ),
    closeIconSize: iconfontSizeNormal,
    buttonWidth: 110,
    height: 360,
    pickerTextStyle: TextStyle(
      color: Colors.black,
      fontSize: textfontSizeApp,
      fontWeight: fontWeightMedium,
      letterSpacing: letterSpacingSmall,
    ),
    dismissable: true,
    minDateTime: DateTime(1900),
    maxDateTime: DateTime.now(),
    dateOrder: DatePickerDateOrder.dmy,
    onSubmit: (date) {
      final dateString = DateFormat('dd/MM/yyyy').format(date);
      controller.text = dateString;
    },
  ).show(context);
}
