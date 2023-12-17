import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String passwordKey = 'Rhoebie'; // Use a strong and secure key for encryption.

  String encrypt(String text) {
    var result = '';
    for (int i = 0; i < text.length; i++) {
      var charCode = text.codeUnitAt(i) + passwordKey.codeUnitAt(i % passwordKey.length);
      result += String.fromCharCode(charCode);
    }
    return base64Encode(utf8.encode(result));
  }

  String decrypt(String text) {
    var encryptedBytes = utf8.decode(base64Decode(text));
    var result = '';
    for (int i = 0; i < encryptedBytes.length; i++) {
      var charCode = encryptedBytes.codeUnitAt(i) - passwordKey.codeUnitAt(i % passwordKey.length);
      result += String.fromCharCode(charCode);
    }
    return result;
  }

  _uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref = _storage.ref().child('profilePics').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return await encrypt(downloadUrl);
  }

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }

  Future<String> signUpUsers(String email, String fullName, String address,
      String phoneNumber, String password, Uint8List? image) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          address.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // Create the user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String profileImageUrl = await _uploadProfileImageToStorage(image);

        await _firestore.collection('buyers').doc(cred.user!.uid).set({
          'email': encrypt(email),
          'fullName': encrypt(fullName),
          'phoneNumber': encrypt(phoneNumber),
          'buyerId': cred.user!.uid,
          'address': encrypt(address),
          'profileImage': profileImageUrl,
        });

        res = 'success';
      } else {
        res = 'Please Fields must not be empty';
      }
    } catch (e) {
      // Handle errors appropriately
      print(e.toString());
    }

    return res;
  }

  Future<String> loginUsers(String email, String password) async {
    String res = 'something went wrong';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);

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