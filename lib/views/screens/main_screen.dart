

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:rental_app_web_admin/views/screens/side_bar_screen/categories_screen.dart';
import 'package:rental_app_web_admin/views/screens/side_bar_screen/owners_screen.dart';
import 'package:rental_app_web_admin/views/screens/side_bar_screen/products_screen.dart';
import 'package:rental_app_web_admin/views/screens/side_bar_screen/upload_banner_screen.dart';
import 'package:rental_app_web_admin/views/screens/side_bar_screen/user_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Widget _selectedItem = OwnerScreen();


  screenSlector(item){
    switch (item.route){
      case OwnerScreen.routeName:
      setState(() {
        _selectedItem = OwnerScreen();
      });

      break;
      case UserScreen.routeName:
      setState(() {
        _selectedItem = UserScreen();
      });

      break;
      case ProductScreen.routeName:
      setState(() {
        _selectedItem = ProductScreen();
      });

      // break;
      // case OrderScreen.routeName:
      // setState(() {
      //   _selectedItem = OrderScreen();
      // });

      break;
      case CategoriesScreen.routeName:
      setState(() {
        _selectedItem = CategoriesScreen();
      });

      break;
      case UploadBannerScreen.routeName:
      setState(() {
        _selectedItem = UploadBannerScreen();
      });

      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
    
      sideBar: SideBar(items: [
        AdminMenuItem(
          title: 'Owners',
          icon: CupertinoIcons.person_3,
          route: OwnerScreen.routeName
          ),
        AdminMenuItem(
          title: 'User',
          icon: Icons.person,
          route: UserScreen.routeName
          ),
          AdminMenuItem(
          title: 'Reservation',
          icon: Icons.house,
          route: ProductScreen.routeName
          ),
        // AdminMenuItem(
        //   title: 'Approved',
        //   icon: CupertinoIcons.heart,
        //   route: OrderScreen.routeName
        //   ),
          AdminMenuItem(
          title: 'Catogories',
          icon: Icons.category,
          route: CategoriesScreen.routeName
          ),
          AdminMenuItem(
          title: 'Upload Banners',
          icon: CupertinoIcons.add,
          route: UploadBannerScreen.routeName
          ),
      ], selectedRoute: '', onSelected: (item){
        screenSlector(item);
      },
      header: Container(
          height: 40,
          width: double.infinity,
          color: Color.fromRGBO(55, 99, 150, 1),
          child: const Center(
            child: Text(
              'Rental App Panel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),

        // footer: ListTile(
        //   onTap: () async {
        //     await _auth.signOut().whenComplete(() {
        //       Navigator.pushReplacement(context,
        //         MaterialPageRoute(builder: (context) {
        //           return AdminLogin();
        //         }));
        //       });
        //     },
        //   leading: Icon(Icons.logout),
        //     title: Text('Logout',
        //     style: TextStyle(
        //     color: Color.fromRGBO(53, 61, 104, 1),
        //   ),),
        // ),
      ),
      body: _selectedItem);
  }
}