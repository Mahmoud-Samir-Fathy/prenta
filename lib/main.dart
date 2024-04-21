import 'package:flutter/material.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:  false,
      home: AccountScreen()
    );
  }
}

