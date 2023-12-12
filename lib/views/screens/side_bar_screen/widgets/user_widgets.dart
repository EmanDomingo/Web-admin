

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({super.key});

  Widget buyerData ( int? flex, Widget widget) {

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
    final Stream<QuerySnapshot> _buyersStream = FirebaseFirestore.instance.collection('buyers').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _buyersStream,
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

            final buyerUserData = snapshot.data!.docs[index];
          return Container(
      child: Row(
        children: [
          buyerData(1, Container(
            height: 50,
            width: 50,
            child: Image.network(buyerUserData['profileImage']),
          ),
          ),

          buyerData(1, Text(
            buyerUserData['fullName'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          buyerData(4, Text(
            buyerUserData['address'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          buyerData(1, Text(
            buyerUserData['phoneNumber'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          buyerData(2, Text(
            buyerUserData['email'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
              ],
              )
            );
          },
        );
      },
    );
  }
}