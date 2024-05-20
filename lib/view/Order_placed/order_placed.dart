import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../shared/components/components.dart';

class OrderPlaced extends StatefulWidget {
  const OrderPlaced({Key? key}) : super(key: key);

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  List<Map<String, dynamic>> cartItems = [
    {
      'image': 'images/wishlisttshirt.png',
      'title': 'Hawaiian Shirts for Men',
      'size': 'M',
      'price': '90',
      'quantity': 1,
    },
    {
      'image': 'images/wishlisttshirt.png',
      'title': 'Hawaiian Shirts for Men',
      'size': 'L',
      'price': '75',
      'quantity': 1,
    },
    {
      'image': 'images/wishlisttshirt.png',
      'title': 'Hawaiian Shirts for Men',
      'size': 'L',
      'price': '75',
      'quantity': 1,
    },
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('FCFCFC'),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          'My Order',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: Container(
                            width: constraints.maxWidth * 0.30,
                            height: constraints.maxWidth * 0.30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(item['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(item['title']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text('Qty (${item['quantity']})'),
                                  SizedBox(width: 30),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blueGrey,
                                    child: Text(
                                      '${item['size']}',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text('${item['price']} EG'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Order Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Items (${calculateTotalQuantity()})',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${calculateSubtotal()} LE',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '50 LE', // Assuming fixed shipping cost
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey[500]),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${calculateTotal() + 50} LE', // Adding shipping cost to total
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: defaultMaterialButton(
                    text: 'Continue Shopping', Function: () {})),
          ),
        ],
      ),
    );
  }

  // Calculate total amount
  double calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += double.parse(item['price']) * item['quantity'];
    }
    return total;
  }

  // Calculate subtotal amount
  double calculateSubtotal() {
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += double.parse(item['price']) * item['quantity'];
    }
    return subtotal;
  }

  // Calculate total quantity
  int calculateTotalQuantity() {
    int totalQuantity = 0;
    for (var item in cartItems) {
      totalQuantity += item['quantity'] as int;
    }
    return totalQuantity;
  }
}
