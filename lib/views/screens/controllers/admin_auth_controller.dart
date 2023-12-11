

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String>adminsignUpUSers(
    String Email, String fullName, String phoneNumber, String Password,) async {
      String res = 'Some error occored';


      try {
        if (
          Email.isNotEmpty &&
          fullName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          Password.isNotEmpty) {
            //create the user
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
              email: Email, password: Password);


          await _firestore.collection('admin').doc(cred.user!.uid).set({
            'Email':Email,
            'fullName': fullName,
            'phoneNumber': phoneNumber,
            'adminId': cred.user!.uid,
            }
          );
              res = 'success';
          } else {
            res = 'Please Fields must not be empty';
          }
      } catch (e) {
        
      }

      return res;
    }

    adminLoginUsers( String Email, String Password) async {
      String res = 'something went wrong';

      try {
        if (Email.isNotEmpty && Password.isNotEmpty) {
          await _auth.signInWithEmailAndPassword(
            email: Email, password: Password);
          
          res = 'success';
        } else {
          res = 'Please Fields must not be empty';
        }
      } catch (e) {
        res = e.toString();
      }

      return res;
    }
}