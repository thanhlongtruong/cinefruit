import 'package:ceni_fruit/curvedclipper.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedTime;

  List<List<String>> seatStatus = List.generate(
    6,
    (_) => List.filled(11, 'available'),
  );
  List<String> selectedSeats = [];
  List<String> doubleSeats = [
    'G1 G2',
    'G3 G4',
    'G5 G6',
    'G7 G8',
    'G9 G10',
    'G11 G12',
  ];

  String getSeatCode(int row, int col) {
    String rowLetter = String.fromCharCode(65 + row);
    return '$rowLetter${col + 1}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 13),
          ),
        ),
        title: Text(
          'Galaxy Cine + Gold Coast Nha Trang',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildMovieAndDropDown(),
              buildScreen(),
              const SizedBox(height: 40),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildSeatLayout(),
                      const SizedBox(height: 10),
                      buildDoubleSeatRow(),
                      const SizedBox(height: 30),
                      buildLegend(),
                      const SizedBox(height: 20),
                      buildPrice(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMovieAndDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lilo & Stich',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          width: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              alignment: Alignment.center,
              value: selectedTime,
              hint: const Text(
                'Chọn',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              style: const TextStyle(color: Colors.black, fontSize: 18),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
                size: 25,
              ),
              items:
                  ["13:00", "15:00", "17:00", "20:00"].map((time) {
                    return DropdownMenuItem<String>(
                      value: time,
                      child: Center(
                        // căn giữa trong menu xổ xuống
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTime = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSeatLayout() {
    return Column(
      children: List.generate(6, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(11, (col) {
            final seatCode = getSeatCode(row, col);
            bool isDouble = doubleSeats.contains(seatCode);
            bool isSelected = selectedSeats.contains(seatCode);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedSeats.contains(seatCode)) {
                    selectedSeats.remove(seatCode);
                  } else {
                    selectedSeats.add(seatCode);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.all(4),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.orange
                          : isDouble
                          ? Colors.purple[100]
                          : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget buildScreen() {
    return Expanded(
      flex: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(3.1416),
          child: ClipPath(
            clipper: CurvedScreenClipper(),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(3.1416),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 50,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/stitch.jpg',
                    ), // ← ảnh của bạn
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDoubleSeatRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          doubleSeats.map((seatCode) {
            final isSelected = selectedSeats.contains(seatCode);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedSeats.remove(seatCode);
                  } else {
                    selectedSeats.add(seatCode);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.all(3),
                width: 49, // Ghế đôi rộng hơn
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.purple[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    seatCode,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              legendItem(Colors.white, 'Ghế đơn'),
              const SizedBox(width: 45),
              legendItem(Colors.purple[100]!, 'Ghế đôi'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              legendItem(Colors.orange, 'Đang chọn'),
              const SizedBox(width: 31),
              legendItem(Colors.grey, 'Đã bán'),
            ],
          ),
        ],
      ),
    );
  }

  Widget legendItem(Color color, String label) {
    //
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget buildPrice() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '400,000đ',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Tiếp tục',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
