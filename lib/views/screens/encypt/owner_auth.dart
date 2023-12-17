import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class OwnerController {

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  //Function to store image in firebase store
  _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref = _storage.ref().child('storeImages').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return await encrypt(downloadUrl);

  }
  //Function to store image in firebase storage ends here

  //Function to pick store image
  pickStoreImage(ImageSource source) async{
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }
  //Function to pick store image ends here

  //Function to save owners data
  Future <String> registerOwner(
    String bussinessName,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    // String taxRegistered,
    // String taxNumber,
    
    Uint8List? image,) async {

      String res = 'some error occured';

      try {
        
            String storeImage = await _uploadVendorImageToStorage(image);
            //Save data to cloud firestore

            await _firestore
            .collection('owners')
            .doc(_auth.currentUser!.uid)
            .set({
              'bussinessName': encrypt(bussinessName),
              'email': encrypt(email),
              'phoneNumber': encrypt(phoneNumber),
              'countryValue':encrypt(countryValue),
              'stateValue':encrypt(stateValue),
              'cityValue':encrypt(cityValue),
              // 'taxRegistered':taxRegistered,
              // 'taxNumber':taxNumber,
              'storeImage':storeImage,
              'approved':false,
              'ownerId':_auth.currentUser!.uid,
            });
          ;
      } catch (e) {
        res = e.toString();
      }

      return res;
  }
  //Function to save owners data ends here
}