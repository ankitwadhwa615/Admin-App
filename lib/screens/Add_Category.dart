import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/Category.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool isloading = false;
  CategoryService categoryService = CategoryService();
  TextEditingController _categoryEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  final picker = ImagePicker();
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add Category', style: TextStyle(color: Colors.black)),
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
            child: Column(
                children: <Widget>[
                  //========================image uploaders=======================================================
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.2), width: 2.0),
                          onPressed: () {
                            getImage();
                          },
                          child: displayChild()),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _categoryEditingController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                            labelText: 'Category:', hintText: 'Enter Category:'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Category can't be empty";
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
          ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FlatButton(
          onPressed: uploadCategory,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add Category    ',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getImage() async {
    final  pickedImg = await picker.getImage(source: ImageSource.gallery);
    setState(() => _image = File(pickedImg.path));
  }

  Widget displayChild() {
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(
        _image,
        fit: BoxFit.fill,
      );
    }
  }

  void uploadCategory() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      if (_image != null) {
        String imageUrl;

        final FirebaseStorage storage = FirebaseStorage.instance;

        final String picture =
            "${DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()}.jpg";
        StorageUploadTask task = storage.ref().child(picture).putFile(_image);

        task.onComplete.then((snapshot) async {
          imageUrl = await snapshot.ref.getDownloadURL();
          categoryService.createCategory(
              name: _categoryEditingController.text, imageUrl: imageUrl);
          setState(() {
            isloading = false;
          });
          Fluttertoast.showToast(
            msg: "Category uploaded successfully",
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
          Navigator.pop(context);
        });
      } else {
        setState(() {
          isloading = false;
        });
        Fluttertoast.showToast(
            msg: "image cant be empty",
            backgroundColor: Colors.black,
            textColor: Colors.white);
      }
    }
  }
}
