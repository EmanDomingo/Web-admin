

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ApprovedWidget extends StatelessWidget {
//   const ApprovedWidget({super.key});

//   Widget approvedData ( int? flex, Widget widget) {

//     return Expanded(
//       flex: flex! ,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color:  Colors.grey)
//         ),
      
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: widget,
//         ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _approvedStream = FirebaseFirestore.instance.collection('orders').snapshots();
//     final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//     return StreamBuilder<QuerySnapshot>(
//       stream: _approvedStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text("Loading");
//         }

//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index){

//             final approvedUserData = snapshot.data!.docs[index];
//           return Container(
//       child: Row(
//         children: [
//           approvedData(1, Container(
//             height: 50,
//             width: 50,
//             child: Image.network(approvedUserData['userPhoto']),
//           ),),
//           approvedData(2, Text(
//             approvedUserData['fullName'],
//             style: TextStyle(
//               fontWeight: FontWeight.bold),),),
//           approvedData(2, Text(
//             approvedUserData['phone'],
//             style: TextStyle(
//               fontWeight: FontWeight.bold),),),
//           approvedData(2, Text(
//             approvedUserData['productName'],
//             style: TextStyle(
//               fontWeight: FontWeight.bold),),),
//           approvedData(1, Text(
//             approvedUserData['productPrice'].toStringAsFixed(2),
//             style: TextStyle(
//               fontWeight: FontWeight.bold),),),
//           approvedData(1,
//           approvedUserData['accepted'] == false
//           ?ElevatedButton(onPressed: () async {
//             await _firestore
//             .collection('orders')
//             .doc(approvedUserData['orderId'])
//             .update({
//               'accepted':true,
//             });
//           },
//           child: Text('Accepted'))
//           :ElevatedButton(onPressed: () async {
//             await _firestore
//             .collection('orders')
//             .doc(approvedUserData['orderId'])
//             .update({
//               'accepted':false,
//             });
//           },
//           child: Text('Reject'),),),
//               ],
//               )
//             );
//           },
//         );
//       },
//     );
//   }
// }