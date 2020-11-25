import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/db/Sold.dart';


class SoldOrderDetails extends StatefulWidget {
  final indexOfOrder;
  SoldOrderDetails({
    @required this.indexOfOrder,
});
  @override
  _SoldOrderDetailsState createState() => _SoldOrderDetailsState();
}

class _SoldOrderDetailsState extends State<SoldOrderDetails> {
  SoldProductService _soldProductService=SoldProductService();
  List<DocumentSnapshot> soldOrders = <DocumentSnapshot>[];
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    _getSoldOrders();
  }

  _getSoldOrders() async {
    setState(() {
      isloading = true;
    });
    List<DocumentSnapshot> data = await _soldProductService.getSoldProducts();
    setState(() {
      soldOrders = data;
      _getProducts();
      isloading = false;
    });
  }

  _getProducts() async {
    setState(() {
      isloading = true;
    });
    List<DocumentSnapshot> data = await _soldProductService
        .getOrderedProducts(soldOrders[widget.indexOfOrder]['id']);
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
          'Completed Order Details',
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
                        '${soldOrders[widget.indexOfOrder]['name']}',
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
                            '${soldOrders[widget.indexOfOrder]['mobileNo']}',
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
                                '${soldOrders[widget.indexOfOrder]['address']} '
                                    '${soldOrders[widget.indexOfOrder]['locality']},',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                '${soldOrders[widget.indexOfOrder]['city']}'
                                    ', '
                                    '${soldOrders[widget.indexOfOrder]['state']}',
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
                            soldOrders[widget.indexOfOrder]['pinCode'],
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
                            soldOrders[widget.indexOfOrder]
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
                            '${soldOrders[widget.indexOfOrder]['totalAmount']}',
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
                            '${soldOrders[widget.indexOfOrder]['date']}/${soldOrders[widget.indexOfOrder]['month'
                                '']}/${soldOrders[widget.indexOfOrder]['year']}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
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
}
