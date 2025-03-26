import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route; 

  MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}

final List<MenuItem> menuItems = [
  MenuItem(
      title: "Object Detection",
      subtitle: "Deteksi objek di sekitar Anda",
      icon: Icons.camera_alt,
      color: Colors.blue.shade100,
      route: "/detection"),
  MenuItem(
      title: "Scan Text",
      subtitle: "Arahkan kamera ke teks yang kamu inginkan",
      icon: Icons.text_fields,
      color: Colors.grey.shade300,
      route: "/scan_text"),
  MenuItem(
      title: "Color Detection",
      subtitle: "Identifikasi warna objek secara optimal",
      icon: Icons.color_lens,
      color: Colors.grey.shade300,
      route: "/color_detection"),
  MenuItem(
      title: "Money Detection",
      subtitle: "Kenali uang dengan kamera",
      icon: Icons.attach_money,
      color: Colors.grey.shade300,
      route: "/money_detection"),
  MenuItem(
      title: "Live Location",
      subtitle: "Bagikan lokasi Anda secara real-time",
      icon: Icons.location_on,
      color: Colors.grey.shade300,
      route: "/live_location"),
  MenuItem(
      title: "See For Me AI",
      subtitle: "Gunakan suara atau teks dan tanyakan ke AI",
      icon: Icons.chat_bubble_outline_outlined,
      color: Colors.grey.shade300,
      route: "/see_for_me_ai"),
];
