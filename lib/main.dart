import 'package:flutter/material.dart';
import 'package:josenian_quiri/screens/homepage.dart';
import 'package:josenian_quiri/screens/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),

      home: Loading(),
    );
  }
}
