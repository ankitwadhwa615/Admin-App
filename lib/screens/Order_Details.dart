import 'package:admin_panel/screens/Orders_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/db/Orders.dart';
import 'package:admin_panel/db/Sold.dart';
import 'package:uuid/uuid.dart';

class OrderDetails extends StatefulWidget {
  final indexOfOrder;
  final date;
  final month;
  final year;
  final paymentMethod;
  final orderDateTime;
  final totalAmount;
  final name;
  final mobileNo;
  final pinCode;
  final address;
  final locality;
  final city;
  final state;
  OrderDetails({
      @required this.year,
      @required this.month,
      @required this.date,
    @required this.paymentMethod,
      @required this.indexOfOrder,
      @required this.orderDateTime,
      @required this.totalAmount,
      @required this.name,
      @required this.address,
      @required this.mobileNo,
      @required this.pinCode,
      @required this.locality,
      @required this.state,
      @required this.city});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrdersService _ordersService = OrdersService();
  SoldProductService _soldProductService=SoldProductService();
  List<DocumentSnapshot> orders = <DocumentSnapshot>[];
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  bool isloading = false;
  DateTime now=DateTime.now();
  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  _getOrders() async {
    setState(() {
      isloading = true;
    });
    List<DocumentSnapshot> data = await _ordersService.getOrders();

    setState(() {
      orders = data;
      _getproducts();
      isloading = false;
    });
  }

  _getproducts() async {
    setState(() {
      isloading = true;
    });
    List<DocumentSnapshot> data = await _ordersService
        .getOrderedProducts(orders[widget.indexOfOrder]['id']);
    setState(() {
      products = data;
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Order Details',
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: isloading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: <Widget>[
                                  Text(
                                    'UserName :',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${orders[widget.indexOfOrder]['name']}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'User Contact no:',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${orders[widget.indexOfOrder]['mobileNo']}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Text(
                                        'Shipping Address:',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '${orders[widget.indexOfOrder]['address']} '
                                            '${orders[widget.indexOfOrder]['locality']},',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            '${orders[widget.indexOfOrder]['city']}'
                                            ', '
                                            '${orders[widget.indexOfOrder]['state']}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Pin-Code:',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        orders[widget.indexOfOrder]['pinCode'],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Payment Method:',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        orders[widget.indexOfOrder]
                                            ['paymentMethod'],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Total Amount:',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${orders[widget.indexOfOrder]['totalAmount']}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Order Date:',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${orders[widget.indexOfOrder]['date']}/${orders[widget.indexOfOrder]['month'
                                            '']}/${orders[widget.indexOfOrder]['year']}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  showAlertDialog(context, widget.indexOfOrder);
                                },
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'order completed',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 590,
                        child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
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
                                                    child: Image.network(
                                                        '${products[index]['images'][0]}')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Card(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'Quantity: ${products[index]['quantity']} ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '${products[index]['brand']}',
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            bottom: 5.0),
                                                    child: Text(
                                                      '${products[index]['description']}',
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        'category:',
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            '${products[index]['category']}'),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        'Size:',
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            '${products[index]['size']}'),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        '₹${products[index]['currentPrice']}',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        '${products[index]['oldPrice']}',
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
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
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
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
       orderCompleted();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OrdersList()));
        setState(() {
          isloading=false;
        });
      },
    );
    AlertDialog alert=AlertDialog(

      title: Center(child: Column(
        children: <Widget>[
          Icon(Icons.warning,size: 120,color: Colors.red.withOpacity(0.9),),
          SizedBox(height: 15,),
          Text('The Order will be removed')
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
  void orderCompleted() {
    var id = Uuid();
    String soldId = id.v1();
    _soldProductService.uploadSoldUsersDetails(
      dateOfCompletion: now.day.toString(),
        monthOfCompletion: now.month.toString(),
        yearOfCompletion: now.year.toString(),
        dateTimeOfCompletion: now.toString(),
        orderDateTime: widget.orderDateTime,
        month: widget.month,
        date:  widget.date,
        year:  widget.year,
        soldId: soldId,
        name: widget.name,
        mobileNo: widget.mobileNo,
        address: widget.address,
        locality: widget.locality,
        pinCode: widget.pinCode,
        city: widget.city,
        state: widget.state,
        paymentMethod: widget.paymentMethod,
        totalAmount: widget.totalAmount);
    for (int index = 0; index < products.length; index++) {
      _soldProductService.uploadSoldProducts(
       soldId:soldId,
        category:  products[index]['category'],
        brand: products[index]['brand'],
        description: products[index]['description'],
        details: products[index]['details'],
        currentPrice: products[index]['currentPrice'],
        oldPrice: products[index]['oldPrice'],
        size: products[index]['size'],
        quantity: products[index]['quantity'],
        images: products[index]['images'],
      );
    }
    for(int i=0;i<products.length;i++){
      _ordersService.deleteProducts(id:orders[widget.indexOfOrder]['id'], index:products[i]['id']);
    }
    _ordersService.deleteData(
       orders[widget.indexOfOrder]['id']
         );

  }
}
