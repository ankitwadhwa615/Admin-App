import 'package:admin_panel/db/Category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}


class _CategoryListState extends State<CategoryList> {
  CategoryService _categoryService = CategoryService();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];

  bool isloading=false;

  @override
  void initState() {
    _getCategories();
    super.initState();
  }
  _getCategories() async {
    setState(() {
      isloading=true;
    });
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      isloading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .1,
        title: Text('Category List',style: TextStyle(color: Colors.black),),
        leading: IconButton(icon:Icon(Icons.close,color: Colors.black,),onPressed:()=> Navigator.pop(context),),
      ),
      body:isloading ? Center(child: CircularProgressIndicator()):ListView.builder(itemCount:categories.length,itemBuilder: (context,index){
        return Card(child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 80,
                child: Image.network("${categories[index]['image']}"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('${categories[index]['category']}',style: TextStyle(fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.only(right:15),
                child: IconButton(icon:Icon(Icons.delete,size: 30,color: Colors.grey,),onPressed: (){
                  showAlertDialog(context, categories[index].documentID);
                },),
              ),
            ],
          ),
        ),);
      }),
    );
  }
  showAlertDialog(BuildContext context,id) {
    Widget cancelButton=FlatButton(
      child: Text('Cancel'),
      onPressed: (){
        Navigator.pop(context);
      },
    );
    Widget continueButton=FlatButton(

      child: Text('Continue'),
      onPressed: (){
        setState(() {
          isloading=true;
        });
        _categoryService.deleteData(id);
        _getCategories();
        setState(() {
          isloading=false;
        });
        Navigator.pop(context);
      },
    );
    AlertDialog alert=AlertDialog(

      title: Center(child: Column(
        children: <Widget>[
          Icon(Icons.warning,size: 120,color: Colors.red.withOpacity(0.9),),
          SizedBox(height: 15,),
          Text('The Category will be deleted')
        ],
      )),
      content: Text('          would u like to continue..') ,
      actions: <Widget>[
        continueButton,
        cancelButton

      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context){
          return alert;
        });
  }
}
