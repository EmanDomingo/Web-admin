import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationWidget extends StatefulWidget {
  const ReservationWidget({super.key});

  @override
  _ReservationWidgetState createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  TextEditingController _searchController = TextEditingController();
  bool _showApproved = true; // Initial state: Show approved items
  int _currentPage = 1;
  int _itemsPerPage = 3;

  Widget reservationData(int? flex, Widget widget) {
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

  
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _reservationStream =
        FirebaseFirestore.instance.collection('products').snapshots();
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

              // Filter buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    color: _showApproved ? Colors.blue : Colors.grey,
                    onPressed: () {
                      setState(() {
                        _showApproved = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_down),
                    color: _showApproved ? Colors.grey : Colors.red,
                    onPressed: () {
                      setState(() {
                        _showApproved = false;
                      });
                    },
                  ),
                ],
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
                    columnSpacing: 150.0,
                    columns: [
                      DataColumn(label: Text('Categories', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: snapshot.data!.docs
                        .where((reservationUserData) {
                          // Apply search filter
                          String productName = reservationUserData['productName'];
                          bool matchesSearch = productName
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase());
                          
                          String category = reservationUserData['category'];
                          bool matchesCategory = category
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase());
                        
                          String productAddress = reservationUserData['productAddress'];
                          bool matchesAddress = productAddress
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase());

                          // Apply approval filter
                          bool isApproved = reservationUserData['approved'] == true;

                          return (matchesSearch || matchesCategory || matchesAddress) &&
                          (_showApproved ? isApproved : !isApproved);
                        })
                        .skip(startIndex)
                        .take(_itemsPerPage)
                        .map((reservationUserData) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  reservationUserData['category'],
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataCell(
                                Text(
                                  reservationUserData['productName'],
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataCell(
                                Text(
                                  reservationUserData['productAddress'],
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataCell(
                                Text(
                                  reservationUserData['productContnum'],
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataCell(
                                Text(
                                  reservationUserData['productPrice'].toStringAsFixed(2),
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                      .where((reservationUserData) {
                        String productName = reservationUserData['productName'];
                        bool matchesSearch = productName
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase());

                        String category = reservationUserData['category'];
                        bool matchesCategory = category
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase());
                        
                        String productAddress = reservationUserData['productAddress'];
                        bool matchesAddress = productAddress
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase());

                        bool isApproved = reservationUserData['approved'] == true;

                        return (matchesSearch || matchesCategory || matchesAddress) && (_showApproved ? isApproved : !isApproved);
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