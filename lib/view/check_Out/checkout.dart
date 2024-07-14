import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() async {
    List<Map<String, dynamic>> items = await CacheHelper.getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('FCFCFC'),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: HexColor('FFFFFF'),
                        child: ListTile(
                          leading: Container(
                            width: constraints.maxWidth * 0.15,
                            height: constraints.maxWidth * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(item['image']), // Use NetworkImage
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(item['title']),
                              Spacer(),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  '${item['size']}',
                                  style: TextStyle(fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${item['price']} EG'),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        item['quantity']++;
                                      });
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Icon(Icons.add, size: 20),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text('${item['quantity']}'),
                                  SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (item['quantity'] > 1) {
                                          item['quantity']--;
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Icon(Icons.remove, size: 20),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cartItems.removeAt(index);
                                      });
                                    },
                                    child: Icon(
                                      Icons.delete, size: 25,
                                    ),
                                  ),
                                ],
                              ),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sub total',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '50 LE', // Assuming fixed shipping cost
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${calculateTotal() + 50} LE', // Adding shipping cost to total
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: defaultMaterialButton(text: 'Check out', Function: () {}),
            ),
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
}
