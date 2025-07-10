import 'package:ceni_fruit/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime parseDate(String dateStr) {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  return dateFormat.parse(dateStr);
}

List<Map<String, String>> getList30Days() {
  final now = DateTime.now().add(const Duration(days: 1));
  final formatDM = DateFormat("dd/MM");
  final weekdayFormat = DateFormat('EEE', 'vi_VN');

  return List.generate(30, (i) {
    final date = DateTime(now.year, now.month, now.day + i);
    return {
      "daymonth": formatDM.format(date),
      "weekday": i == 0 ? "Ngày mai" : weekdayFormat.format(date),
    };
  });
}

Widget buildDayofCinema({
  required int selectedDate,
  required DateTime date,
  required void Function(int index, DateTime date) onSelectDate,
  required VoidCallback funcGetData,
}) {
  final List<Map<String, String>> days = getList30Days();
  return SizedBox(
    height: 70,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: days.length,
      itemBuilder: (context, index) {
        bool isSelected = index == selectedDate;
        final item = days[index];
        final weekday = item['weekday'] ?? '';
        final daymonth = item['daymonth'] ?? '';
        return GestureDetector(
          onTap: () {
            final newDate = parseDate(
              "${days[index]["daymonth"]!}/${DateTime.now().year}",
            );

            onSelectDate(index, newDate);
            funcGetData();
          },
          child: Column(
            spacing: spacingSmall,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[900] : Colors.transparent,
                  borderRadius: borderRadiusButton,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacingBig,
                    vertical: spacingSmall,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekday,
                        style: TextStyle(
                          color: colorTextApp,
                          fontWeight: fontWeightNormal,
                          fontSize: textfontSizeSmall,
                          letterSpacing: letterSpacingSmall,
                        ),
                      ),
                      Text(
                        daymonth,
                        style: TextStyle(
                          color: colorTextApp,
                          fontWeight: fontWeightMedium,
                          fontSize: textfontSizeNote,
                          letterSpacing: letterSpacingSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
