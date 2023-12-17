

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app_web_admin/views/screens/encypt/customer_auth.dart';

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

  String decryptPogi(String text) {
      final authController = AuthController();
      final decodedText = authController.decrypt(text);
      return decodedText;
    }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _buyersStream = FirebaseFirestore.instance.collection('buyers').snapshots();

    final ScrollController _scrollController = ScrollController();
    final ScrollController scrollController2 = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: _buyersStream,
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
                  columnSpacing: 200.0,
                  columns: [
                    DataColumn(label: Text('Image',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Address',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Phone Number',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Email',style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],
                  rows: snapshot.data!.docs.map((buyerUserData) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            height: 40,
                            width: 40,
                            child: Image.network(
                                decryptPogi(buyerUserData['profileImage'])),
                          ),
                        ),
                        DataCell(
                          Text(
                            decryptPogi(buyerUserData['fullName']),
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            decryptPogi(buyerUserData['address']),
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            decryptPogi(buyerUserData['phoneNumber']),
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            decryptPogi(buyerUserData['email']),
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
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