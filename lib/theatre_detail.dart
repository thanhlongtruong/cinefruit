import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/filmoftheatre.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class TheatreDetail extends StatefulWidget {
  final Cinema cinema;
  const TheatreDetail({super.key, required this.cinema});

  @override
  State<TheatreDetail> createState() => _TheatreDetailState();
}

class _TheatreDetailState extends State<TheatreDetail> {
  @override
  Widget build(BuildContext context) {
    logger.d(widget.cinema);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        title: Text(
          widget.cinema.name,
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Colors.blue[900], size: 14),
                SizedBox(width: 4),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      widget.cinema.address,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          buildDayofCinema(),
          Expanded(child: SingleChildScrollView(child: buildCinema())),
        ],
      ),
    );
  }

  Widget buildDayofCinema() {
    List<String> dates = ['4/6', '5/6', '6/6', '7/6', '8/6', '9/6'];
    int selectedIndex = 1;
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[400]!),
                    bottom: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[900] : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hôm nay',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          dates[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCinema() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: movies.map((movie) => buildMovieCard(movie)).toList(),
      ),
    );
  }

  Widget buildMovieCard(FilmOfTheatre movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(movie.imagePath, height: 130, width: 100),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            movie.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.history_outlined, color: Colors.amber),
                            Text('${movie.duration} phút'),
                            SizedBox(width: 20),
                            Icon(Icons.calendar_month, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(movie.releaseDate),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            SizedBox(width: 4),
                            Text(
                              '${movie.rating}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children:
              movie.showTimes
                  .map(
                    (time) =>
                        OutlinedButton(onPressed: () {}, child: Text(time)),
                  )
                  .toList(),
        ),
        Divider(thickness: 1),
      ],
    );
  }
}
