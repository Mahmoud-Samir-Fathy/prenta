import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

import '../../shared/components/components.dart';

class ReviewAfter extends StatefulWidget {
  final Map<String, dynamic> item;

  ReviewAfter(this.item);

  @override
  _ReviewAfterState createState() => _ReviewAfterState();
}
class _ReviewAfterState extends State<ReviewAfter> {
  double rating = 0;
  final reviewController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return BlocConsumer<PrentaCubit,PrentaStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit=PrentaCubit.get(context);
       return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Review',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] ?? 'Unknown Item',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '${item['price'] ?? '0.00'} L.E.',
                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                        ],
                      ),
                      Spacer(),
                      Image(
                        image: NetworkImage(item['image'] ?? 'images/testorder.png'),
                        height: 100,
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 15),
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
                      cubit.updateRating(rating);
                    }
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
                        controller: reviewController,
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
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: defaultMaterialButton(
                        text: 'Post Review',
                        Function: () {
                          print('Rating: $rating');
                          print('Review: ${reviewController.text}');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
