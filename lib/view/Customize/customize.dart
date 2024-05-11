import 'dart:io';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/components/components.dart';

class customize extends StatefulWidget {
  const customize({super.key});

  @override
  State<customize> createState() => _customizeState();
}

class _customizeState extends State<customize> {
  int selectedCircle=0;
  final List<Color> circleColors = [
    Colors.black,
    Colors.white,
HexColor('012639'),
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green
    ,
  ];
  File? image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HexColor('FFFFFF'),
      statusBarIconBrightness: Brightness.dark,
    ));

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    height: 290,
                    width: double.infinity,
                    child: Image.asset('images/customizeimage.png',fit: BoxFit.cover,)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
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
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 12),
              child: Row(
                children: [
                  Text('300'),
        SizedBox(width: 4,),
                  Text('LE')],
              ),
            ),
            SizedBox(height: 15,),
            Text('Sized:'),
            SizedBox(height: 10,),
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
                  textStyle: TextStyle(fontSize: 16)),
              radioButtonValue: (value) {
                print(value);
              },height: 55,
              width: 55,
              selectedColor: HexColor('27374D'),
            ),
            SizedBox(height: 10,),
            Text('Colors available:'),
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
                      border: Border.all(color: selectedCircle== 1|| selectedCircle!= 1? Colors.black45 :circleColors[index] ), // Add this line for a black border


                      color: circleColors[index], // Use the color from the list
                    ),
                    child: Center(
                      child: selectedCircle == index
                          ? Icon(Icons.check, color: selectedCircle!= 1? Colors.white:Colors.black)
                          : Container(),
                    ),
                  ),
                );
              }),
            ),
          ),
            SizedBox(height: 10,),
            Text('Insert Image:'),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: getImage,
              child: Center(
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: HexColor('526D82').withOpacity(0.2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: image == null
                      ? Icon(Icons.image, color: Colors.white)
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.file(
                      image!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),            SizedBox(height: 10,),
            Text('Design position:'),
            SizedBox(height: 10,),

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
                'LM',
                'RM',
                'UM',
                'BM',
                'M',
                'RU',
                'LU',
                'MU',
                'LB',
                'RB',
                'MB',
              ],
              buttonValues: [
                'LM',
                'RM',
                'UM',
                'BM',
                'M',
                'RU',
                'LU',
                'MU',
                'LB',
                'RB',
                'MB',
              ],
              buttonTextStyle: ButtonTextStyle(

                  selectedColor: Colors.white,
                  unSelectedColor: HexColor('252525'),
                  textStyle: TextStyle(fontSize: 13)),
              radioButtonValue: (value) {
                print(value);
              },height: 55,
              width: 55,
              selectedColor: HexColor('27374D'),
            ),
            SizedBox(height: 30,),

            Center(
              child: Container(
                width: 320,
                height: 100,
                decoration: BoxDecoration(
                  color: HexColor('526D82').withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20), // Circular radius for the container
                ),
                child: CustomRadioButton(
                  defaultSelected: 'Front',
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 6.0,vertical: 25),
                  radius: 5,
                  shapeRadius: 10,
                  enableShape: true,
                  unSelectedBorderColor: HexColor('526D82').withOpacity(0.2),
                  absoluteZeroSpacing: false,
                  unSelectedColor: Color(0xFF526D82).withOpacity(0.4),
                  buttonLables: ['Front', 'Back'],
                  buttonValues: ['Front', 'Back'],
                  buttonTextStyle: ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.white,
                    textStyle: TextStyle(fontSize: 13),
                  ),
                  radioButtonValue: (value) {
                    print(value);
                  },
                  height: 20,
                  width: 130,
                  selectedColor: Color(0xFF27374D),
                ),
              ),
            ),

            SizedBox(height: 15,),
            Center(child: defaultMaterialButton(text: 'Confirm', Function: (){})),
            SizedBox(height: 15,)
          ],
        ),
      ),
    ));
  }
}
