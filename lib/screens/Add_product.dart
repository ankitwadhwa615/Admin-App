import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/Product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/Category.dart';
import '../db/Brand.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();

  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _displayNameEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();
  TextEditingController _productDetailsEditingController =
      TextEditingController();
  TextEditingController _priceEditingController = TextEditingController();
  TextEditingController _oldPriceEditingController = TextEditingController();
  TextEditingController _quantityEditingController = TextEditingController();

  List<String> selectedSizes = <String>[];
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropdown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem> brandsDropdown = <DropdownMenuItem>[];
  String _currentCategory;
  String _currentBrand;
  bool isloading=false;

  final picker = ImagePicker();
  File _image1;
  File _image2;
  File _image3;

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getBrand();
    //brandsDropdown = getBrandsDropdown();
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
        title: Text("add product", style: TextStyle(color: Colors.black)),
      ),
      body: Form(
        key: _formKey,
        child: isloading? Center(child: CircularProgressIndicator()): SingleChildScrollView(
          child:Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Enter product details',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
              ),
            ),
//===================================upload Images===============================================
            Row(
              children: <Widget>[
                //========================image uploaders=======================================================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.2), width: 2.0),
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
                            color: Colors.black.withOpacity(0.2), width: 2.0),
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
//===============================================================================================

//===================================select brand================================================
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: _currentBrand != null,
                child: InkWell(
                  child: Card(
                    borderOnForeground: true,
                    color: Colors.white,
                    child: ListTile(
                      subtitle: Text(
                        "${_currentBrand ?? 'null'}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                      title: Text(
                        'selected brand:',
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _currentBrand = null;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _currentBrand == null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      style: TextStyle(),
                      decoration:
                          InputDecoration(hintText: 'Product Brand name')),
                  suggestionsCallback: (pattern) async {
                    return await _brandService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.collections_bookmark),
                      title: Text("${suggestion['brand']}"),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      _currentBrand = suggestion['brand'];
                    });
                  },
                ),
              ),
            ),
//===============================================================================================
            //====================DisplayName=============================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _displayNameEditingController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    labelText: 'Display name of product:',
                    hintText: 'Enter Product Display Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Display name can't be empty";
                  } else if (value.length > 12) {
                    return 'The Display name cant be greater than 12 characters';
                  }
                },
              ),
            ),
            //====================Description=============================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _descriptionEditingController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    labelText: 'Product Description:',
                    hintText: 'Enter Product description:'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Description can't be empty";
                  }
                },
              ),
            ),
            //====================Details=============================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _productDetailsEditingController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    labelText: 'Product details:',
                    hintText: 'Enter Product details:'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Product details can't be empty";
                  }
                },
              ),
            ),
            //====================Current Price=============================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _priceEditingController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    labelText: 'Product current price:',
                    hintText: 'Enter Product current price:'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Product price can't be empty";
                  }
                },
              ),
            ),
            //====================Old price=============================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _oldPriceEditingController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    labelText: 'Product old price:',
                    hintText: 'Enter Product old price:'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Product old price can't be empty";
                  }
                },
              ),
            ),
            //====================Quantity=============================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _quantityEditingController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    labelText: 'Product Quantity:',
                    hintText: 'Enter Product quantity available:'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Product quantity can't be empty";
                  }
                },
              ),
            ),

            //=======Select Category========================================================
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Select Category:  ',
                    style: TextStyle(fontSize: 15),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                      items: categoriesDropdown,
                      value: _currentCategory,
                      onChanged: changeSelectedCategory,
                    ),
                  ),
                ],
              ),
            ),
            //========================Size checkbox==============================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Available Sizes:',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: selectedSizes.contains('7'),
                    onChanged: (value) => changeSelectedSize("7"),
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                  ),
                  Text('7'),
                  Checkbox(
                    value: selectedSizes.contains('8'),
                    onChanged: (value) => changeSelectedSize("8"),
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                  ),
                  Text('8'),
                  Checkbox(
                    value: selectedSizes.contains('9'),
                    onChanged: (value) => changeSelectedSize("9"),
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                  ),
                  Text('9'),
                  Checkbox(
                    value: selectedSizes.contains('10'),
                    onChanged: (value) => changeSelectedSize("10"),
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                  ),
                  Text('10'),
                  Checkbox(
                    value: selectedSizes.contains('11'),
                    onChanged: (value) => changeSelectedSize("11"),
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                  ),
                  Text('11'),
                ],
              ),
            ),

            //====================================Add Product Button====================================

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlatButton(
                onPressed: validateAndUpload,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Add product    ',
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
          ]),
        ),
      ),
    );
  }

//=======================================================Methods==========================================================

  void getImage( int imageNumber) async {
    final tempImg = await picker.getImage(source: ImageSource.gallery);

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

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data['category']),
              value: categories[i].data['category'],
            ));
      });
    }
    return items;
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropdown = getCategoriesDropdown();
      _currentCategory = categories[0].data['category'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  _getBrand() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
      brands = data;
    });
  }

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.add(size);
      });
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isloading=true;
      });
      if (_image1 != null && _image2 != null && _image3 != null) {
        if (selectedSizes.isNotEmpty) {
          if (_currentBrand != null) {
            String imageUrl1;
            String imageUrl2;
            String imageUrl3;

            final FirebaseStorage storage = FirebaseStorage.instance;

            final String picture1 =
                "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
            StorageUploadTask task1 =
                storage.ref().child(picture1).putFile(_image1);

            final String picture2 =
                "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
            StorageUploadTask task2 =
                storage.ref().child(picture2).putFile(_image2);

            final String picture3 =
                "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
            StorageUploadTask task3 =
                storage.ref().child(picture3).putFile(_image3);

            StorageTaskSnapshot snapshot1 =
                await task1.onComplete.then((snapshot) => snapshot);
            StorageTaskSnapshot snapshot2 =
                await task2.onComplete.then((snapshot) => snapshot);

            task3.onComplete.then((snapshot3) async {
              imageUrl1 = await snapshot1.ref.getDownloadURL();
              imageUrl2 = await snapshot2.ref.getDownloadURL();
              imageUrl3 = await snapshot3.ref.getDownloadURL();

              List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

              productService.uploadProducts(
                dateTime: DateTime.now().toString(),
                brand: _currentBrand,
                displayName: _displayNameEditingController.text,
                description: _descriptionEditingController.text,
                details: _productDetailsEditingController.text,
                currentPrice: double.parse(_priceEditingController.text),
                oldPrice:double.parse(_oldPriceEditingController.text),
                quantity: int.parse(_quantityEditingController.text),
                category: _currentCategory,
                sizes: selectedSizes,
                images:imageList,
              );
              _formKey.currentState.reset();
              setState(() {
                isloading=false;
              });
              Fluttertoast.showToast(msg: "Product added successfully",backgroundColor: Colors.black,textColor: Colors.white,);
              Navigator.pop(context);
            });
          } else {
            setState(() {
              isloading=false;
            });
            Fluttertoast.showToast(msg: "Brand name can't be empty",backgroundColor: Colors.black,textColor: Colors.white);
          }
        } else {
          setState(() {
            isloading=false;
          });
          Fluttertoast.showToast(msg: 'Select atleast one size',backgroundColor: Colors.black,textColor: Colors.white);
        }
      } else {
        setState(() {
          isloading=false;
        });
        Fluttertoast.showToast(msg: 'All Images must be provided',backgroundColor: Colors.black,textColor: Colors.white);
      }
    }
  }

}
































//          Center(
//              child: DropdownButton(
//                  items: brandsDropdown,
//                  value: _currentBrand,
//                  onChanged: (selectedBrand) {
//                    setState(() {
//                      _currentBrand = selectedBrand;
//                    });
//                  })),
//
//  List<DropdownMenuItem<String>> getBrandsDropdown() {
//    List<DropdownMenuItem<String>> items = List();
//    for (DocumentSnapshot brand in brands) {
//      items.add(DropdownMenuItem(
//        child: Text(brand['brand']),
//        value: brand['brand'],
//      ));
//    }
//    return items;
//  }
//Padding(
//            padding: const EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 5),
//            child: Visibility(
//              visible: _currentCategory != null,
//              child: InkWell(
//                child: Card(
//                  color: Colors.white,
//                  child: ListTile(
//                        title: Text(
//                          "${_currentCategory ?? 'null' }",
//                          style: TextStyle(color: Colors.black),
//                        ),
//                      trailing:IconButton(
//                        icon: Icon(
//                          Icons.close,
//                          color: Colors.black,
//                        ),
//                        onPressed: () {
//                          setState(() {
//                            _currentCategory = null;
//                          });
//                        },
//                      )
//                  ),
//                ),
//              ),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.all(16.0),
//            child: TypeAheadField(
//              textFieldConfiguration: TextFieldConfiguration(
//                  autofocus: false,
//                  style: TextStyle(),
//                  decoration: InputDecoration(hintText: 'add category')),
//              suggestionsCallback: (pattern) async {
//                return await _categoryService.getSuggestions(pattern);
//              },
//              itemBuilder: (context, suggestion) {
//                return ListTile(
//                  leading: Icon(Icons.category),
//                  title: Text('${suggestion['category']}'),
//                );
//              },
//              onSuggestionSelected: (suggestion) {
//                setState(() {
//                  _currentCategory = suggestion['category'];
//                });
//              },
//            ),
//          ),
