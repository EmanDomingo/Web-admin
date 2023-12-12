

// import 'package:flutter/material.dart';
// import 'package:rental_app_web_admin/views/screens/side_bar_screen/widgets/approved_widget.dart';

// class OrderScreen extends StatelessWidget {
//   static const String routeName = '\OrderScreen';

//     Widget _rowHeader(String text, int flex) {
//     return Expanded(
//       flex: flex,
//       child: Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         color: Colors.blue.shade300,
//         boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade600,
//                     spreadRadius: 1,
//                     blurRadius: 2,
//                     offset: const Offset(0, 3),
//                     ),
//                   ]
//         ),

//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             text,
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               alignment: Alignment.topLeft,
//               padding: const EdgeInsets.all(10),
//               child: const Text(
//                 'Approved Reservation',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 36,
//                 ),
//               ),
//             ),

//             Row(children: [
//               _rowHeader('USER IMAGE', 1),
//               _rowHeader('USER NAME', 2),
//               _rowHeader('USER PHONE', 2),
//               _rowHeader('OWNER NAME', 2),
//               _rowHeader('PRICE', 1),
//               _rowHeader('ACTION', 1),
//               ],
//             ),
//             ApprovedWidget(),
//           ],
//         ),
//       );
//     }
//   }