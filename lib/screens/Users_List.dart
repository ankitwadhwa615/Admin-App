import 'package:admin_panel/db/Users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}


class _UsersListState extends State<UsersList> {
  UserServices _usersService = UserServices();
  List<DocumentSnapshot> users = <DocumentSnapshot>[];

  bool isloading = false;

  @override
  void initState() {
    _getBrand();
    super.initState();
  }

  _getBrand() async {
    setState(() {
      isloading = true;
    });
    List<DocumentSnapshot> data = await _usersService.getUser();
    setState(() {
      users = data;
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .1,
        title: Text('Users List', style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black,),
          onPressed: () => Navigator.pop(context),),
      ),
      body: isloading ? Center(child: CircularProgressIndicator()) : ListView
          .builder(itemCount: users.length, itemBuilder: (context, index) {
        return Card(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('UserName:',style: TextStyle(fontSize: 18,color: Colors.black),),
                    Text(
                      '${users[index]['username']}', style: TextStyle(fontSize: 18),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Email-id:',style: TextStyle(fontSize: 18,color: Colors.black),),
                    Text(
                      '${users[index]['email']}', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('User-id:',style: TextStyle(fontSize: 18,color: Colors.black),),
                    Text(
                      '${users[index]['id']}', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ],
          ),
        ),);
      }),
    );
  }
}

