import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rental_app_web_admin/views/screens/side_bar_screen/widgets/category_widget.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '/categories';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  dynamic _image;

  String? fileName;

  late String categoryName;

  _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;

        fileName = result.files.first.name;
      });
    }
  }

  _uploadCategoryBannersToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('categoryImage').child(fileName!);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  uploadCategory() async {
    EasyLoading.show();
    if (_formkey.currentState!.validate()) {
      String imageUrl = await _uploadCategoryBannersToStorage(_image);

      await _firestore.collection('categories').doc(fileName).set({
        'image': imageUrl,
        'categoryName': categoryName,
      }).whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _image = null;
          _formkey.currentState!.reset();
        });
      });
    } else {
      print('OH Bad Guy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              border: Border.all(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _image != null
                                ? Image.memory(
                                    _image,
                                    fit: BoxFit.cover,
                                  )
                                : Center(
                                    child: Text('Category'),
                                  ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: Color.fromRGBO(75, 156, 248, 1),
                            ),
                            onPressed: () {
                              _pickImage();
                            },
                            child: Text(
                              'Upload Image',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: constraints.maxWidth < 600
                            ? constraints.maxWidth
                            : 180,
                        child: TextFormField(
                          onChanged: (value) {
                            categoryName = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Category Name Must not be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Category Name',
                            hintText: 'Enter Category Name',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        primary: Color.fromRGBO(75, 156, 248, 1),
                      ),
                      onPressed: () {
                        uploadCategory();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                CategoryWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}