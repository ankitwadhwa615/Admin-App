import 'package:admin_panel/db/Brand.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class BrandList extends StatefulWidget {
  @override
  _BrandListState createState() => _BrandListState();
}


class _BrandListState extends State<BrandList> {
  BrandService _brandService = BrandService();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];

bool isloading=false;
  @override
  void initState() {
    _getBrand();
    super.initState();
  }
  _getBrand() async {
    setState(() {
      isloading=true;
    });
    List<DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
      brands = data;
      isloading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .1,
        title: Text('Brand List',style: TextStyle(color: Colors.black),),
        leading: IconButton(icon:Icon(Icons.close,color: Colors.black,),onPressed:()=> Navigator.pop(context),),
      ),
      body:isloading ? Center(child: CircularProgressIndicator()):ListView.builder(itemCount:brands.length,itemBuilder: (context,index){
        return Card(child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('${brands[index]['brand']}',style: TextStyle(fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.only(right:15),
                child: IconButton(icon:Icon(Icons.delete,size: 30,color: Colors.grey,),onPressed: (){showAlertDialog(context, brands[index].documentID);},),
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
        _brandService.deleteData(id);
        _getBrand();
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
          Text('The Brand will be deleted')
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
