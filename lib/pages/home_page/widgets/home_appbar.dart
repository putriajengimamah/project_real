// [KODE YANG UDAH AKU TAMBAHIN SEMANTICS BUAT OPTIMALIN FITUR TALKBACK]

import 'package:flutter/material.dart';
import 'package:project_real/utils/greeting_helper.dart'; // Import helper

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting(); // Panggil dari helper

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Semantics(
        excludeSemantics: true, // Supaya TalkBack nggak bacain lagi
        child: Text(
          greeting,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}









// [KODE YANG BELOM AKU TAMBAHIN SEMANTICS BUAT OPTIMALIN FITUR TALKBACK]
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const HomeAppBar({super.key});

//   String getGreeting() {
//     int hour = int.parse(DateFormat.H().format(DateTime.now()));
//     if (hour >= 0 && hour < 12) {
//       return "Selamat Pagi";
//     } else if (hour >= 12 && hour < 15) {
//       return "Selamat Siang";
//     } else if (hour >= 15 && hour < 19) {
//       return "Selamat Sore";
//     } else {
//       return "Selamat Malam";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       title: Text(
//         getGreeting(),
//         style: const TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
