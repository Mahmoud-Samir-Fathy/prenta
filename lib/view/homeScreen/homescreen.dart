import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'itemcard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('Welcome Back!'), Text('Mahmoud Samir')],
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: HexColor('F6F6F6'),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'What are you looking for...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: HexColor('D9D9D9'),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Shop with us!'),
                          Text('Get 40% Off for all items'),
                          Row(
                            children: [
                              Text('Shop Now'),
                              Icon(Icons.arrow_forward_outlined)
                            ],
                          ),
                        ],
                      ),
                      Image.asset(
                        'images/image.png', // Replace with your image URL
                        width: 100, // Set appropriate width and height for the image
                        height: 100,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                CustomRadioButton(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  defaultSelected: 'All',
                  radius: 4,
                  shapeRadius: 40,
                  enableShape: true,
                  unSelectedBorderColor: Colors.white,
                  absoluteZeroSpacing: false,
                  unSelectedColor: HexColor('526D82').withOpacity(0.2),
                  buttonLables: [
                    'All',
                    'T-Shirt',
                    'Hoodle',
                    'Special',
                  ],
                  buttonValues: [
                    'All',
                    'T-Shirt',
                    'Hoodle',
                    'Special',
                  ],
                  buttonTextStyle: ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: HexColor('252525'),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  radioButtonValue: (value) {
                    print(value);
                  },
                  height: 30,
                  width: 90,
                  selectedColor: HexColor('27374D'),
                ),
                SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items per row
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 30,
                    childAspectRatio: 0.58, // Adjust the aspect ratio as needed
                  ),
                  itemCount: 10, // Number of items
                  itemBuilder: (context, index) {
                    return ItemCard();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


