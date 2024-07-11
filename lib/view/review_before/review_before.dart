import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

class ReviewBefore extends StatelessWidget{
  String text='asdaslk;djasldjaskl;dja;sldkjas;ldkasl/dklaskd;laskd;laskd;laskd;laskd;lasjdlasmd.,asmd.,asmd.,asmd.asmd.asd.,asmd.,asmd.,asdm.,asdm.,asdm.,asdm.,asdm.,asdm.,asdm.,asd\n';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
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
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context,index)=>buildReviewComments(text),
                  separatorBuilder: (context,index)=>SizedBox(height: 10,),
                  itemCount: 10),
            )
          ],),
      ),
    );
  }
}
Widget buildReviewComments(text)=> Card(
color: Colors.white,
child: Padding(
padding: const EdgeInsets.all(8.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
  children: [
    Text(
    'Mahmoud Samir',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(width: 30),
    RatingBar.builder(
    itemSize: 25,
    initialRating: 4,
    minRating: 1,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 0.03),
    itemBuilder: (context, _) => Icon(
    Icons.star,
    color: Colors.amber,
    ),
    onRatingUpdate: (rating) {},
    ignoreGestures: true, // This makes the RatingBar read-only
    ),
  ],
),
SizedBox(height: 10),
ReadMoreText(
text,
trimLines: 3,
trimMode: TrimMode.Line,
textAlign: TextAlign.justify,
trimCollapsedText: 'Show More',
trimExpandedText: 'Show Less',
lessStyle: TextStyle(
fontSize: 16, color: Colors.blue[500], fontWeight: FontWeight.bold).copyWith(height: 1.5),
moreStyle: TextStyle(
fontSize: 16, color: Colors.blue[500], fontWeight: FontWeight.bold).copyWith(height: 1.5),
style: TextStyle(fontSize: 16),
),
],
),
),
);