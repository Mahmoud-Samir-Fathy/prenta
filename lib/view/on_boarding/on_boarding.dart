import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/on_board_model/on_board_model.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../login&register_screen/account_screen/account_screen.dart';

class OnBoarding extends StatelessWidget {
  OnBoarding({super.key});

  final PageController boardController = PageController();

  void submit(BuildContext context) {
    CacheHelper.saveData(key: 'OnBoarding', value: true).then((value) {
      if (value) {
        navigateAndFinish(context, const AccountScreen());
      }
    });
  }

  List<onBoardingModel> get boarding => [
    onBoardingModel(
        image: ('images/onboard1.png'),
        tittle: 'Now You Can Customize \nYour Own Product',
        description:
        'Create a product that reflects your unique style by designing it exactly the way you want. From choosing colors to adding personal touches, make it truly yours.'),
    onBoardingModel(
        image: ('images/onboard2.png'),
        tittle: 'Discover Unique Designs',
        description:
        'Browse through a variety of products featuring our own design ideas. From stylish apparel to eye-catching accessories, find something that resonates with your style.'),
    onBoardingModel(
        image: ('images/onboard3.png'),
        tittle: 'Get Your Product Quickly',
        description:
        'With just a few simple clicks, we\'ll swiftly deliver the product you choose as fast as possible. Your satisfaction is our priority, and we\'re committed to getting your order to you promptly.')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              submit(context);
            },
            child: Text('SKIP', style: TextStyle(color: firstColor)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  if (index == boarding.length - 1) {
                    // Last page reached
                  }
                },
                controller: boardController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  effect: ExpandingDotsEffect(
                    dotColor: secondColor,
                    activeDotColor: firstColor,
                    dotWidth: 10,
                    dotHeight: 10,
                    expansionFactor: 4,
                    radius: 10,
                    spacing: 5,
                  ),
                  controller: boardController,
                  count: boarding.length,
                ),
                const Spacer(),
                FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: firstColor,
                  elevation: 0,
                  onPressed: () {
                    if (boardController.page == boarding.length - 1) {
                      submit(context);
                    } else {
                      boardController.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastEaseInToSlowEaseOut,
                      );
                    }
                  },
                  child: Icon(
                    Ionicons.chevron_forward_outline,
                    color: forthColor,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(onBoardingModel onboard) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage(onboard.image),
        ),
      ),
      Text(
        onboard.tittle,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 40),
      Text(
        onboard.description,
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 30),
    ],
  );
}
