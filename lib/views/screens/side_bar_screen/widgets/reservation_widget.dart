

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

    final ScrollController _scrollController = ScrollController();
    final ScrollController scrollController2 = ScrollController();


    return StreamBuilder<QuerySnapshot>(
      stream: _reservationStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 15.0,
              controller: scrollController2,
              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                controller: scrollController2,
                  child:DataTable(
                    headingRowColor:MaterialStateColor.resolveWith((states) => Color.fromRGBO(75, 156, 248, 1),),
                  columnSpacing: 150.0,
                  columns: [
                    DataColumn(label: Text('Categories',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Address',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Phone Number',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Price',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Action',style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],
                  rows: snapshot.data!.docs.map((reservationUserData) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            reservationUserData['category'],
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            reservationUserData['productName'],
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            reservationUserData['productAddress'],
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            reservationUserData['productContnum'],
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            reservationUserData['productPrice'].toStringAsFixed(2),
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          reservationUserData['approved'] == false
                              ? ElevatedButton(
                                  onPressed: () async {
                                    await _firestore
                                        .collection('products')
                                        .doc(reservationUserData['productId'])
                                        .update({
                                      'approved': true,
                                    });
                                  },
                                  child: Text('Approved'),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    await _firestore
                                        .collection('products')
                                        .doc(reservationUserData['productId'])
                                        .update({
                                      'approved': false,
                                    });
                                  },
                                  child: Text('Reject'),
                                ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

        );
      },
    );
  }
}


