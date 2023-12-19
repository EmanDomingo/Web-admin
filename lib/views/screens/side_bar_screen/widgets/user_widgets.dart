import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app_web_admin/views/screens/encypt/customer_auth.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 3;

  Widget buyerData(int? flex, Widget widget) {
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
    final authController = AuthController();
    final decodedText = authController.decrypt(text);
    return decodedText;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _buyersStream =
        FirebaseFirestore.instance.collection('buyers').snapshots();

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

        // Calculate the start and end index for pagination
        int startIndex = (_currentPage - 1) * _itemsPerPage;
        int endIndex = startIndex + _itemsPerPage;

        int totalItems = snapshot.data!.docs.length;
        int totalPages = (totalItems / _itemsPerPage).ceil();

        // Generate a list of page numbers for pages with data
        List<int> pageNumbers = List.generate(totalPages, (index) => index + 1);

        return Container(
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        // Reset the stream to get all data again
                        setState(() {});
                      },
                    ),
                  ),
                  onChanged: (value) {
                    // Filter the data based on the search query
                    setState(() {});
                  },
                ),
              ),

              // DataTable
              Scrollbar(
                thumbVisibility: true,
                thickness: 15.0,
                controller: scrollController2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController2,
                  child: DataTable(
                    headingRowColor:
                        MaterialStateColor.resolveWith((states) => Color.fromRGBO(75, 156, 248, 1)),
                    columnSpacing: 200.0,
                    columns: [
                      DataColumn(label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: snapshot.data!.docs
                        .where((buyerUserData) {
                          // Apply search filter
                          String fullName = decryptPogi(buyerUserData['fullName']);
                          bool matchesSearch = fullName
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());

                          bool matchesAddress= decryptPogi(buyerUserData['address'])
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase());

                          bool matchesEmail = decryptPogi(buyerUserData['email'])
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase());

                          return matchesSearch || matchesAddress || matchesEmail;
                        })
                        .skip(startIndex)
                        .take(_itemsPerPage)
                        .map((buyerUserData) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.network(decryptPogi(buyerUserData['profileImage'])),
                                ),
                              ),
                              DataCell(
                                Text(
                                  decryptPogi(buyerUserData['fullName']),
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataCell(
                                Text(
                                  decryptPogi(buyerUserData['address']),
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataCell(
                                Text(
                                  decryptPogi(buyerUserData['phoneNumber']),
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataCell(
                                Text(
                                  decryptPogi(buyerUserData['email']),
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          );
                        })
                        .toList(),
                  ),
                ),
              ),

              // Pagination buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pageNumbers.map((pageNumber) {
                  List<DocumentSnapshot> pageData = snapshot.data!.docs
                      .where((buyerUserData) {
                        String fullName = decryptPogi(buyerUserData['fullName']);
                          bool matchesSearch = fullName
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());

                          bool matchesAddress= decryptPogi(buyerUserData['address'])
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase());

                          bool matchesEmail = decryptPogi(buyerUserData['email'])
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase());

                          return matchesSearch || matchesAddress || matchesEmail;
                      })
                      .skip((pageNumber - 1) * _itemsPerPage)
                      .take(_itemsPerPage)
                      .toList();

                  if (pageData.isNotEmpty) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentPage = pageNumber;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _currentPage == pageNumber ? Colors.blue : null,
                      ),
                      child: Text('$pageNumber'),
                    );
                  } else {
                    return Container(); // Empty container for pages with no data
                  }
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}