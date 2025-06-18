class FilmOfTheatre {
  final String id;
  final String title;
  final String imagePath;
  final String ageRating;
  final int duration; // phút
  final String releaseDate;
  final double rating;
  final String format;
  final List<String> showTimes;

  FilmOfTheatre({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.ageRating,
    required this.duration,
    required this.releaseDate,
    required this.rating,
    required this.format,
    required this.showTimes,
  });
}

final List<FilmOfTheatre> movies = [
  FilmOfTheatre(
    id: '1',
    title: 'Lilo & Stitch',
    imagePath: 'assets/images/phim_1.png',
    ageRating: 'T18',
    duration: 100,
    releaseDate: '25/04/2025',
    rating: 9.5,
    format: '2D Lồng Tiếng',
    showTimes: ['8:30', '10:45', '13:00', '15:15'],
  ),
  FilmOfTheatre(
    id: '2',
    title: 'Lost in Starlight',
    imagePath: 'assets/images/phim_2.png',
    ageRating: 'P',
    duration: 95,
    releaseDate: '22/03/2025',
    rating: 8.8,
    format: '2D Phụ Đề',
    showTimes: ['9:00', '11:30', '14:00', '16:30'],
  ),
  FilmOfTheatre(
    id: '3',
    title: 'The Last of Us',
    imagePath: 'assets/images/phim_3.png',
    ageRating: 'P',
    duration: 95,
    releaseDate: '22/03/2025',
    rating: 8.8,
    format: '2D Phụ Đề',
    showTimes: ['9:00', '11:30', '14:00', '16:30'],
  ),
  FilmOfTheatre(
    id: '4',
    title: 'Until Dawn',
    imagePath: 'assets/images/phim_4.png',
    ageRating: 'P',
    duration: 95,
    releaseDate: '22/03/2025',
    rating: 8.8,
    format: '2D Phụ Đề',
    showTimes: ['9:00', '11:30', '14:00', '16:30'],
  ),
  FilmOfTheatre(
    id: '5',
    title: 'A Minecraft Movie',
    imagePath: 'assets/images/phim_5.png',
    ageRating: 'P',
    duration: 95,
    releaseDate: '22/03/2025',
    rating: 8.8,
    format: '2D Phụ Đề',
    showTimes: ['9:00', '11:30', '14:00', '16:30'],
  ),
  FilmOfTheatre(
    id: '6',
    title: 'Mission: Impossible - The Final Reckoning',
    imagePath: 'assets/images/phim_6.png',
    ageRating: 'P',
    duration: 95,
    releaseDate: '22/03/2025',
    rating: 8.8,
    format: '2D Phụ Đề',
    showTimes: ['9:00', '11:30', '14:00', '16:30'],
  ),
  FilmOfTheatre(
    id: '7',
    title: 'Dept. Q',
    imagePath: 'assets/images/phim_7.png',
    ageRating: 'P',
    duration: 95,
    releaseDate: '22/03/2025',
    rating: 8.8,
    format: '2D Phụ Đề',
    showTimes: ['9:00', '11:30', '14:00', '16:30'],
  ),
  FilmOfTheatre(
    id: '8',
    title: 'Sinners',
    imagePath: 'assets/images/phim_8.png',
    ageRating: 'P',
    duration: 95,
    releaseDate: '22/03/2025',
    rating: 8.8,
    format: '2D Phụ Đề',
    showTimes: ['9:00', '11:30', '14:00', '16:30'],
  ),
];
