class Movie {
  final String id;
  final String name;
  final String urlImage;
  final String? description;

  Movie({
    required this.id,
    required this.name,
    required this.urlImage,
    this.description,
  });
}

final List<Movie> movies = [
  Movie(id: "1", name: "Lilo & Stitch", urlImage: "assets/images/phim_1.png"),
  Movie(
    id: "2",
    name: "Lost in Starlight",
    urlImage: "assets/images/phim_2.png",
  ),
  Movie(id: "3", name: "The Last of Us", urlImage: "assets/images/phim_3.png"),
  Movie(id: "4", name: "Until Dawn", urlImage: "assets/images/phim_4.png"),
  Movie(
    id: "5",
    name: "A Minecraft Movie",
    urlImage: "assets/images/phim_5.png",
  ),
  Movie(
    id: "6",
    name: "Mission: Impossible - The Final Reckoning",
    urlImage: "assets/images/phim_6.png",
  ),
  Movie(id: "7", name: "Dept. Q", urlImage: "assets/images/phim_7.png"),
  Movie(id: "8", name: "Sinners", urlImage: "assets/images/phim_8.png"),
];
