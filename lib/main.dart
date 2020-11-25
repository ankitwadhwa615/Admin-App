import 'package:flutter/material.dart';
import 'package:admin_panel/screens/Admin.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Admin(),
    );
  }
}
