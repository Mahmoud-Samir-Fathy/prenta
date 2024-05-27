import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class wishlist extends StatefulWidget {
  const wishlist({super.key});

  @override
  State<wishlist> createState() => _wishlistState();
}

class _wishlistState extends State<wishlist> {
  List<Map<String, dynamic>> wishList = [
    {
      'image': 'images/wishlisttshirt.png',
      'title': 'Hawaiian Shirts for Men ',
      'size': 'Medium M',
      'price': '50',
      'quantity': 1,
    },
    {
      'image': 'images/wishlisttshirt.png',
      'title': 'Hawaiian Shirts for Men ',
      'size': ' Large L',
      'price': '75',
      'quantity': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        backgroundColor: Colors.white,
        title: Text('Wishlist'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Ionicons.search),
            onPressed: (){},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 600) {
                  // Large screens
                  return ListView.builder(
                    itemCount: wishList.length,
                    itemBuilder: (context, index) {
                      final item = wishList[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0), // Increased padding for larger screens
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(item['image'], width: 150, height: 150), // Adjusted image size
            
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title'], style: TextStyle(fontSize: 20)), // Adjusted font size
                                  Text('Size: ${item['size']}'),
                                  Text('Price: ${item['price']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (item['quantity'] > 1) {
                                          item['quantity']--;
                                        }
                                      });
                                    },
                                  ),
                                  Text('${item['quantity']}'),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        item['quantity']++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // Small screens
                  return ListView.builder(
                    itemCount: wishList.length,
                    itemBuilder: (context, index) {
                      final item = wishList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal:4.0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0), // No rounded corners
                            side: BorderSide(
                              color: Colors.black12, // Grey border color
                              width: 1, // Border thickness
                            ),
                          ),
                          elevation: 0, // Removes the shadow
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        wishList.removeAt(index);
                                      });
                                    },
                                    behavior: HitTestBehavior.translucent, // Respond to taps within the entire area of the GestureDetector
                                    child: Icon(Ionicons.close),
                                  )
                                  ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(item['image'], width: 100, height: 100,fit: BoxFit.cover,), // Adjusted image size
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['title'], style: TextStyle(fontSize: 16)), // Adjusted font size
                                        Text('Size: ${item['size']}' ,style: TextStyle(color: Colors.black45),),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 27,
                                              width: 27,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: IconButton(
                                                  icon: Icon(Icons.remove, color: Colors.white, size: 12),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (item['quantity'] > 1) {
                                                        item['quantity']--;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 7),
                                            Text('${item['quantity']}'),
                                            SizedBox(width: 7),
                                            Container(
                                              height: 27,
                                              width: 27,
                                              decoration: BoxDecoration(
                                                color: Colors.blueAccent,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: IconButton(
                                                  icon: Icon(Icons.add, color: Colors.white, size: 12),
                                                  onPressed: () {
                                                    setState(() {
                                                      item['quantity']++;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(' ${item['price']} LE'),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:12.0,vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2, // Adjust the flex value as needed
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                          side: BorderSide(color: Colors.black45), // Black border
                        ),
                      ),
                    ),
                    child: Text(
                      'Remove all',
                      style: TextStyle(color: Colors.black), // Black text
                    ),
                  ),
                ),
                SizedBox(width: 10), // Add some space between the buttons
                Expanded(
                  flex: 3, // Adjust the flex value as needed
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black38),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                        ),
                      ),
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(color: Colors.white), // White text
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}