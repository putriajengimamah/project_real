// import 'package:flutter/material.dart';

// class CameraPreviewOverlay extends StatelessWidget {
//   const CameraPreviewOverlay({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       child: Center(
//         child: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.white, width: 2),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class CameraPreviewOverlay extends StatelessWidget {
  const CameraPreviewOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}
