import 'package:admin_panel/db/Carousel_Images.dart';
import 'package:admin_panel/db/Orders.dart';
import 'package:admin_panel/screens/Add_Category.dart';
import 'package:admin_panel/screens/Category_list.dart';
import 'package:admin_panel/screens/Orders_list.dart';
import 'package:admin_panel/screens/SoldList.dart';
import 'package:admin_panel/screens/Users_List.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admin_panel/db/Category.dart';
import 'package:admin_panel/db/Brand.dart';
import 'package:admin_panel/screens/Add_product.dart';
import '../screens/Brand_List.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/Product_List.dart';
import '../db/Product.dart';
import '../db/Users.dart';
import '../db/Sold.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  ProductService _productService = ProductService();
  BrandService _brandService = BrandService();
  UserServices _userService = UserServices();
  CategoryService _categoryService = CategoryService();
  OrdersService ordersService = OrdersService();
  SoldProductService soldProductService = SoldProductService();
  List<DocumentSnapshot> soldOrders = <DocumentSnapshot>[];
  List<DocumentSnapshot> orders = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  List<DocumentSnapshot> users = <DocumentSnapshot>[];
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  double revenue=0;
  bool isLoading = false;

  _getCategories() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      isLoading = false;
    });
  }

  _getBrands() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
      brands = data;
      isLoading = false;
    });
  }

  _getSoldOrders() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data = await soldProductService.getSoldProducts();
    setState(() {
      soldOrders = data;
      isLoading = false;
    });
  }

  _getOrders() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data = await ordersService.getOrders();
    setState(() {
      orders = data;
      isLoading = false;
    });
  }

  _getProduct() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data = await _productService.getProducts();
    setState(() {
      products = data;
      isLoading = false;
    });
  }

  _getUsers() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data = await _userService.getUser();
    setState(() {
      users = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getCategories();
    _getProduct();
    _getUsers();
    _getSoldOrders();
    _getOrders();
    _getBrands();
    super.initState();
  }
 double getRevenue(){
    double calcRevenue=0;
    for(int i=0;i<soldOrders.length;i++){
      calcRevenue+=soldOrders[i]['totalAmount'];
    }
    return revenue=calcRevenue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle:  Text('₹ ${getRevenue()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0, color: Colors.green)),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => UsersList()));
                      },
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.people_outline),
                                label: Text("Users")),
                            subtitle: Text(
                              '${users.length}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => OrdersList()));
                      },
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.shopping_cart),
                                label: Text("Orders")),
                            subtitle: Text(
                              '${orders.length}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SoldOrdersList()));
                      },
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.tag_faces),
                                label: Text("Sold")),
                            subtitle: Text(
                              '${soldOrders.length}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => CategoryList()));
                      },
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  Icons.category,
                                  size: 15,
                                ),
                                label: Text("Category"
                                    "")),
                            subtitle: Text(
                              categories.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ProductList()));
                      },
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.track_changes),
                                label: Text(
                                  "Products",
                                  style: TextStyle(fontSize: 13),
                                )),
                            subtitle: Text(
                              products.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BrandList()));
                      },
                      child: Card(
                         child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.format_bold),
                                label: Text("Brands")),
                            subtitle: Text(
                              '${brands.length}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 35, left: 20, right: 20),
              child: FlatButton(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white),
                    ),

                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                    )
                  ],
                ),
                onPressed: () {
                  _getUsers();
                  _getCategories();
                  _getProduct();
                  _getOrders();
                  _getSoldOrders();
                  _getBrands();
                  getRevenue();
                },
              ),
            )
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddCategory()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add brand"),
              onTap: () {
                _brandAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add Carousal Images"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CarouselImages()));
              },
            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  void _brandAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value) {
            if (value.isEmpty) {
              return 'category cannot be empty';
            }
          },
          decoration: InputDecoration(hintText: "add brand"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (brandController.text != null) {
                _brandService.createBrand(brandController.text);
              }
              Fluttertoast.showToast(
                  msg: 'brand added',
                  backgroundColor: Colors.black,
                  textColor: Colors.white);
              Navigator.pop(context);
            },
            child: Text('ADD')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
