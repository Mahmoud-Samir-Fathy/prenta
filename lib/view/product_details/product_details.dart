import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:printa/shared/components/components.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

int selectedCircle = 0;
final List<Color> circleColors = [
  Colors.black,
  Colors.white,
  HexColor('012639'),
  Colors.red,
  Colors.blue,
  Colors.yellow,
  Colors.green,
];

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Container(
                  alignment: Alignment.topCenter, // Align image at the top
                  child: Image.asset(
                    'images/productdetails.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.35,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Full Shirt',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                // Add your onPressed logic here
                              },
                              icon: Icon(
                                Icons.favorite, // This icon represents a heart
                                color: Colors.red, // You can change the color to represent the heart
                                size: 23, // You can adjust the size of the icon
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '300',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8,),
                            Text(
                              'LE',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(width: 8,),
                            RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              // Change the itemSize to your desired size, for example, 30
                              itemSize: 20,
                              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ullamcorper in non at egestas metus auctor ultricies phasellus senectus. Turpis orci donec faucibus turpis malesuada sed diam potenti nulla.',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Size:',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),


                                              TextButton.icon(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  isDismissible: false,
                                                 context: context,
                                                  builder: (_) => Container(
                                                    height: MediaQuery.of(context).size.height * 0.5,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: InteractiveViewer(
                                                            boundaryMargin: EdgeInsets.all(20),
                                                            minScale: 0.1,
                                                            maxScale: 4,
                                                            child: Image.asset(
                                                              'images/sizechart.png',
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop(); // Close the bottom sheet
                                                              },
                                                              icon:IconButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop(); // Close the bottom sheet
                                                                },
                                                                icon: Container(
                                                                  padding: EdgeInsets.all(8),
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.red,
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            
                                                            ),Text('You Can Zoom',style: TextStyle(color: Colors.grey),)
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );



                                              },
                                              icon: Icon(Icons.info_outline ,color: Colors.black54,),
                                              label: Text(' '),
                                            ),



                                  ],
                                ),
                                SizedBox(height: 8),
                                CustomRadioButton(
                                  elevation: 0,
                                  margin: EdgeInsets.symmetric(horizontal: 6.0), // creates a margin of 16 logical pixels around the container
                                  defaultSelected: 'M',
                                  radius: 5,
                                  shapeRadius: 10,
                                  enableShape: true,
                                  unSelectedBorderColor: Colors.white,
                                  absoluteZeroSpacing: false,
                                  unSelectedColor: HexColor('526D82').withOpacity(0.2),
                                  buttonLables: [
                                    'XS',
                                    'S',
                                    'M',
                                    'L',
                                    'XL',
                                  ],
                                  buttonValues: [
                                    'XS',
                                    'S',
                                    'M',
                                    'L',
                                    'XL',
                                  ],
                                  buttonTextStyle: ButtonTextStyle(
                                      selectedColor: Colors.white,
                                      unSelectedColor: HexColor('252525'),
                                      textStyle: TextStyle(fontSize: 14)),
                                  radioButtonValue: (value) {
                                    print(value);
                                  },
                                  height: 50,
                                  width: 50,
                                  selectedColor: HexColor('27374D'),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Colors Available:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(7, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedCircle = index;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(8),
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: selectedCircle == 1 || selectedCircle != 1 ? Colors.black45 : circleColors[index]),
                                            color: circleColors[index],
                                          ),
                                          child: Center(
                                            child: selectedCircle == index
                                                ? Icon(Icons.check, color: selectedCircle != 1 ? Colors.white : Colors.black)
                                                : Container(),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Center(child: defaultMaterialButton(text: 'Add To Cart', Function: (){})),
                                SizedBox(height: 15,)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 24,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
