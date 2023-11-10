

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationWidget extends StatelessWidget {
  const ReservationWidget({super.key});

  Widget reservationData ( int? flex, Widget widget) {

    return Expanded(
      flex: flex! ,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
        decoration: BoxDecoration(
          border: Border.all(color:  Colors.grey)
        ),
      
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget,
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _reservationStream = FirebaseFirestore.instance.collection('products').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _reservationStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){

            final reservationUserData = snapshot.data!.docs[index];
          return Container(
      child: Row(
        children: [
          reservationData(1, Text(
            reservationUserData['category'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          reservationData(2, Text(
            reservationUserData['productName'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          reservationData(4, Text(
            reservationUserData['productAddress'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          reservationData(1, Text(
            reservationUserData['productContnum'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          reservationData(1, Text(
            reservationUserData['productPrice'].toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          reservationData(1,
          reservationUserData['approved'] == false
          ?ElevatedButton(onPressed: () async {
            await _firestore
            .collection('products')
            .doc(reservationUserData['productId'])
            .update({
              'approved':true,
            });
          },
          child: Text('Approved'))
          :ElevatedButton(onPressed: () async {
            await _firestore
            .collection('products')
            .doc(reservationUserData['productId'])
            .update({
              'approved':false,
            });
          },
          child: Text('Reject'),),),
              ],
              )
            );
          },
        );
      },
    );
  }
}