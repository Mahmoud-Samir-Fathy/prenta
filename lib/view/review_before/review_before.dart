import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class review_before extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {  },),
        title: Text('Review'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
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
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Mahmoud Samir',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      SizedBox(width: 30,),
                      RatingBar.builder(
                        itemSize: 30,
                        initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: .03),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                        ignoreGestures: true, // This makes the RatingBar read-only
                      )

                    ],
                  ),
                ],
              ),
            )
        ],),
      ),
    );
  }



}