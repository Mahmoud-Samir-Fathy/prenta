import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:printa/models/review_model/review_model.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import 'package:readmore/readmore.dart';

class ReviewBefore extends StatelessWidget {
  final String productTitle;

  ReviewBefore({super.key, required this.productTitle}) {
    if (productTitle.isEmpty) {
      throw ArgumentError('productTitle cannot be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PrentaCubit.get(context).getReview(productTitle );
    });

    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PrentaCubit.get(context);

        if (state is PrentaGetReviewLoadingState) {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text('Reviews'),
              centerTitle: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (cubit.reviewModel.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text('Reviews'),
              centerTitle: true,
            ),
            body: const Center(
              child: Text('No reviews available'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text('Reviews'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 25),

                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildReviewComments(
                      cubit.reviewModel[index],context
                    ),
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                    itemCount: cubit.reviewModel.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


Widget buildReviewComments(ReviewModel? model,context) => Card(
  color: ModeCubit.get(context).isDark?Colors.grey[700]:Colors.white,
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              PrentaCubit.get(context).toCamelCase('${model!.firstName ?? 'No Name'} ${model.lastName ?? ''}'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            RatingBar.builder(
              itemSize: 25,
              initialRating: model.stars?.toDouble() ?? 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 0.03),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
              ignoreGestures: true,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ReadMoreText(
          model.review ?? 'No Review',
          trimLines: 3,
          trimMode: TrimMode.Line,
          textAlign: TextAlign.justify,
          trimCollapsedText: 'Show More',
          trimExpandedText: 'Show Less',
          lessStyle: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ).copyWith(height: 1.5),
          moreStyle: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ).copyWith(height: 1.5),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  ),
);
