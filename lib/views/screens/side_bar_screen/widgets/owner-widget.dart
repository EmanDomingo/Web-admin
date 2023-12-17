import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app_web_admin/views/screens/encypt/owner_auth.dart';

class OwnerWidget extends StatelessWidget {
  const OwnerWidget({Key? key});

  Widget ownerData(int? flex, Widget widget) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      ),
    );
  }

  String decryptPogi(String text) {
    final authController = OwnerController();
    final decodedText = authController.decrypt(text);
    return decodedText;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ownersStream =
        FirebaseFirestore.instance.collection('owners').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final ScrollController _scrollController = ScrollController();
    final ScrollController scrollController2 = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: _ownersStream,
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
                  columnSpacing: 190.0,
                  columns: [
                    DataColumn(label: Text('Image',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Business Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('City',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('State',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Phone Number',style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Action',style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],
                  rows: snapshot.data!.docs.map((ownerUserData) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            height: 40,
                            width: 40,
                            child: Image.network(
                                decryptPogi(ownerUserData['storeImage'])),
                          ),
                        ),
                        DataCell(
                          Text(
                            decryptPogi(ownerUserData['bussinessName']),
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            decryptPogi(ownerUserData['cityValue']),
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            decryptPogi(ownerUserData['stateValue']),
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            decryptPogi(ownerUserData['phoneNumber']),
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          ownerUserData['approved'] == false
                              ? ElevatedButton(
                                  onPressed: () async {
                                    await _firestore
                                        .collection('owners')
                                        .doc(ownerUserData['ownerId'])
                                        .update({
                                      'approved': true,
                                    });
                                  },
                                  child: Text('Approved'),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    await _firestore
                                        .collection('owners')
                                        .doc(ownerUserData['ownerId'])
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