
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CarouselImages extends StatefulWidget {
  @override
  _CarouselImagesState createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  bool isloading = false;
  List<DocumentSnapshot> carouselImages = <DocumentSnapshot>[];

  final picker = ImagePicker();
  File _image1;
  File _image2;
  File _image3;
  File _image4;
  File _image5;
  File _image6;
  _getCarouselImage() async {
    setState(() {
      isloading = true;
    });
    List<DocumentSnapshot> data = await getCarouselImages();
    setState(() {
      carouselImages = data;
      isloading = false;
    });
  }

  @override
  void initState() {
    _getCarouselImage();
    super.initState();
  }

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
        title: Text('Carousel Images', style: TextStyle(color: Colors.black)),
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                //========================image uploaders=======================================================
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 2.0),
                            onPressed: () {
                              getImage(1);
                            },
                            child: displayChild1()),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 2.0),
                            onPressed: () {
                              getImage(2);
                            },
                            child: displayChild2()),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.2), width: 2.0),
                          onPressed: () {
                            getImage(3);
                          },
                          child: displayChild3(),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 2.0),
                            onPressed: () {
                              getImage(4);
                            },
                            child: displayChild4()),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 2.0),
                            onPressed: () {
                              getImage(5);
                            },
                            child: displayChild5()),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.2), width: 2.0),
                          onPressed: () {
                            getImage(6);
                          },
                          child: displayChild6(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FlatButton(
          onPressed: uploadCarouselImages,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add Images    ',
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

  Future getImage( int imageNumber) async {
final tempImg=await picker.getImage(source: ImageSource.gallery);

    switch (imageNumber) {
      case 1:
        setState(() => _image1 = File(tempImg.path));
        break;
      case 2:
        setState(() => _image2 = File(tempImg.path));
        break;
      case 3:
        setState(() => _image3 = File(tempImg.path));
        break;
      case 4:
        setState(() => _image4 = File(tempImg.path));
        break;
      case 5:
        setState(() => _image5 = File(tempImg.path));
        break;
      case 6:
        setState(() => _image6 = File(tempImg.path));
        break;
    }
  }

  Widget displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
      );
    }
  }

  Widget displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(_image2, fit: BoxFit.fill);
    }
  }

  Widget displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(_image3, fit: BoxFit.fill);
    }
  }

  Widget displayChild4() {
    if (_image4 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(
        _image4,
        fit: BoxFit.fill,
      );
    }
  }

  Widget displayChild5() {
    if (_image5 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(
        _image5,
        fit: BoxFit.fill,
      );
    }
  }

  Widget displayChild6() {
    if (_image6 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(
        _image6,
        fit: BoxFit.fill,
      );
    }
  }

  void uploadCarouselImages() async {
    setState(() {
      isloading = true;
    });
    if (_image1 != null &&
        _image2 != null &&
        _image3 != null &&
        _image4 != null &&
        _image5 != null &&
        _image6 != null) {
      String imageUrl1;
      String imageUrl2;
      String imageUrl3;
      String imageUrl4;
      String imageUrl5;
      String imageUrl6;

      final FirebaseStorage storage = FirebaseStorage.instance;

      final String picture1 =
          "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task1 = storage.ref().child(picture1).putFile(_image1);

      final String picture2 =
          "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task2 = storage.ref().child(picture2).putFile(_image2);

      final String picture3 =
          "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task3 = storage.ref().child(picture3).putFile(_image3);
      final String picture4 =
          "4${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task4 = storage.ref().child(picture4).putFile(_image4);

      final String picture5 =
          "5${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task5 = storage.ref().child(picture5).putFile(_image5);

      final String picture6 =
          "6${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task6 = storage.ref().child(picture6).putFile(_image6);

      StorageTaskSnapshot snapshot1 =
          await task1.onComplete.then((snapshot) => snapshot);
      StorageTaskSnapshot snapshot2 =
          await task2.onComplete.then((snapshot) => snapshot);
      StorageTaskSnapshot snapshot3 =
          await task3.onComplete.then((snapshot) => snapshot);
      StorageTaskSnapshot snapshot4 =
          await task4.onComplete.then((snapshot) => snapshot);
      StorageTaskSnapshot snapshot5 =
          await task5.onComplete.then((snapshot) => snapshot);

      task6.onComplete.then((snapshot6) async {
        imageUrl1 = await snapshot1.ref.getDownloadURL();
        imageUrl2 = await snapshot2.ref.getDownloadURL();
        imageUrl3 = await snapshot3.ref.getDownloadURL();
        imageUrl4 = await snapshot4.ref.getDownloadURL();
        imageUrl5 = await snapshot5.ref.getDownloadURL();
        imageUrl6 = await snapshot6.ref.getDownloadURL();

        deleteImage(carouselImages[0].documentID);
        deleteImage(carouselImages[1].documentID);
        deleteImage(carouselImages[2].documentID);
        deleteImage(carouselImages[3].documentID);
        deleteImage(carouselImages[4].documentID);
        deleteImage(carouselImages[5].documentID);
        uploadImage(imageUrl: imageUrl1);
        uploadImage(imageUrl: imageUrl2);
        uploadImage(imageUrl: imageUrl3);
        uploadImage(imageUrl: imageUrl4);
        uploadImage(imageUrl: imageUrl5);
        uploadImage(imageUrl: imageUrl6);
        setState(() {
          isloading = false;
        });
        Fluttertoast.showToast(
          msg: "Images uploaded successfully",
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
          msg: "images cant be empty",
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }
  }

  Firestore _firestore = Firestore.instance;
  String ref = 'carouselImages';

  void uploadImage({
    String imageUrl,
  }) {
    var id = Uuid();
    String imageId = id.v1();

    _firestore.collection(ref).document(imageId).setData({
      'image': imageUrl,
    }).catchError((e) {
      print(e);
    });
  }

  Future<List<DocumentSnapshot>> getCarouselImages() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });
  deleteImage(docId) {
    Firestore.instance
        .collection('carouselImages')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
