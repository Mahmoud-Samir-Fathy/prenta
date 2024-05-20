import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
Row(
  children: [
    Column(
      children: [
        Text('Welcome Back!'),
        Text('Mahmoud Samir')
      ],
    ) ,Spacer(), IconButton(onPressed: (){}, icon: Icon(Icons.notifications)) ,IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart)) ,
  ],
)

        ],
      ),

    );
  }
}
