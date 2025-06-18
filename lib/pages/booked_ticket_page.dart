import 'package:ceni_fruit/config/styles.dart';
import 'package:flutter/material.dart';

class BookedTicketPage extends StatefulWidget {
  const BookedTicketPage({super.key});

  @override
  State<BookedTicketPage> createState() => _BookedTicketPageState();
}

class _BookedTicketPageState extends State<BookedTicketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Booked ticket",
          style: TextStyle(
            fontSize: textfontSizeTitleAppBar,
            color: colorTextApp,
          ),
        ),
        backgroundColor: bgColorApp,
        iconTheme: IconThemeData(color: colorTextApp),
      ),
      backgroundColor: bgColorApp,
      body: Center(
        child: Text(
          "Chưa có vé nào được đặt",
          style: TextStyle(color: colorTextApp, fontSize: textfontSizeApp),
        ),
      ),
    );
  }
}
