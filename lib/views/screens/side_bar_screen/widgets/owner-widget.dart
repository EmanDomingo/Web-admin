

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OwnerWidget extends StatelessWidget {
  const OwnerWidget({super.key});

  Widget ownerData ( int? flex, Widget widget) {

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
    final Stream<QuerySnapshot> _ownersStream = FirebaseFirestore.instance.collection('owners').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _ownersStream,
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

            final ownerUserData = snapshot.data!.docs[index];
          return Container(
      child: Row(
        children: [
          ownerData(1, Container(
            height: 50,
            width: 50,
            child: Image.network(ownerUserData['storeImage']),
          ),
          ),

          ownerData(1, Text(
            ownerUserData['bussinessName'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          ownerData(1, Text(
            ownerUserData['cityValue'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          ownerData(1, Text(
            ownerUserData['stateValue'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          ownerData(1, Text(
            ownerUserData['phoneNumber'],
            style: TextStyle(
              fontWeight: FontWeight.bold),),),
          ownerData(1,
          ownerUserData['approved'] == false
          ?ElevatedButton(onPressed: () async {
            await _firestore
            .collection('owners')
            .doc(ownerUserData['ownerId'])
            .update({
              'approved':true,
            });
          }, child: Text('Approved'))
          :ElevatedButton(onPressed: () async {
            await _firestore
            .collection('owners')
            .doc(ownerUserData['ownerId'])
            .update({
              'approved':false,
            });
          },
          child: Text('Reject'),),),

                ],
              ),
            );
          },
        );
      },
    );
  }
}