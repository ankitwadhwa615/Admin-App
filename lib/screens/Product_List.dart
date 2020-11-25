import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/db/Product.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ProductService _productService = ProductService();
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  bool isloading =false;
  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  _getProduct() async {
    setState(() {
      isloading=true;
    });
    List<DocumentSnapshot> data = await _productService.getProducts();
    setState(() {
      products = data;
      isloading=false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .1,
        title: Text('Products List',style: TextStyle(color: Colors.black),),
        leading: IconButton(icon:Icon(Icons.close,color: Colors.black,),onPressed:()=> Navigator.pop(context),),
      ),
      body:isloading ? Center(child: CircularProgressIndicator()):ListView.builder(itemCount:products.length,itemBuilder: (context,index){
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: 100.0,
                              child: Image.network('${products[index]['images'][0]}')),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Quantity: ${products[index]['quantity']} ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${products[index]['brand']}',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                '${products[index]['description']}',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black54),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'category:',
                                  style: TextStyle(
                                      fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${products[index]['category']}'),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '₹${products[index]['currentPrice']}',
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  '${products[index]['oldPrice']}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: (){
                    showAlertDialog(context,products[index].documentID);
                  },
                  color: Colors.white38,
                  elevation: .3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Remove"),
                      SizedBox(width: 10),
                      Icon(Icons.delete)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
  showAlertDialog(BuildContext context,id) {
    Widget cancleButton=FlatButton(
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
    _productService.deleteData(id);
    _getProduct();
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
          Text('The Product will be deleted')
        ],
      )),
      content: Text('          would u like to continue..') ,
      actions: <Widget>[
        continueButton,
           cancleButton

      ],
    );
    showDialog(
        context: context,
    builder: (BuildContext context){
          return alert;
    });
  }
}
