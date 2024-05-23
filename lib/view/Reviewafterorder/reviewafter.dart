import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../shared/components/components.dart';

class ReviewAfter extends StatefulWidget {
  @override
  _ReviewAfterState createState() => _ReviewAfterState();
}

class _ReviewAfterState extends State<ReviewAfter> {
  double _rating = 0;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {  },),
        title: Text('Review',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mustard Chunky \nCable Knit Sweater',style: TextStyle(fontSize: 20),),
                      Text('25.00 L.E.',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),)
                    ],
                  ),
                  Spacer(),
                  Image(image: AssetImage('images/testorder.png'),height: 100,)
                ],
              ),
              SizedBox(height: 25,),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[400],
              ),
              SizedBox(height: 15,),
              Text(
                'WRITE YOUR REVIEW',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
        
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: HexColor('F6FAFD'),
                  border: Border.all(color: HexColor('E5F0FA')),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 90),
                  child: TextFormField(
                    controller: _reviewController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Write your review here',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )

              ,
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: defaultMaterialButton(
                        text: 'Post Review',
                        Function: () {
                          print('Rating: $_rating');
                          print('Review: ${_reviewController.text}');
                         })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
