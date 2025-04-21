String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour >= 0 && hour < 12) {
    return "Selamat Pagi";
  } else if (hour >= 12 && hour < 15) {
    return "Selamat Siang";
  } else if (hour >= 15 && hour < 19) {
    return "Selamat Sore";
  } else {
    return "Selamat Malam";
  }
}
