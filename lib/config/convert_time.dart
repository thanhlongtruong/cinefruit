Map<String, int>? convertTime(String time) {
  if (time != "") {
    DateTime a = DateTime.parse(
      time,
    ).toLocal().add(const Duration(seconds: 60));
    DateTime b = DateTime.now();

    Duration diff = a.difference(b);

    if (diff.isNegative) {
      return null;
    } else {
      int hours = diff.inHours;
      int minutes = diff.inMinutes % 60;
      int seconds = diff.inSeconds % 60;
      return {"hours": hours, "minutes": minutes, "seconds": seconds};
    }
  }
  return null;
}
