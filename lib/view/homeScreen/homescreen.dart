import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/models/favourite_model/favourite_model.dart';
import 'package:printa/models/product_model/product%20model.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/view/check_Out/checkout.dart';
import 'package:printa/view/notificationScreen/notificationscreen.dart';
import 'package:printa/view/product_details/product_details.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {
        // Handle states if needed
      },
      builder: (context, state) {

        var cubit = PrentaCubit.get(context);


        if (cubit.productInfo.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

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
                          children: [
                            Text('Welcome Back!'),
                            Text('${cubit.userInfo?.firstName ?? ''} ${cubit.userInfo?.lastName ?? ''}'),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () => navigateTo(context, NotificationScreen()),
                          icon: Icon(Ionicons.notifications),
                        ),
                        IconButton(
                          onPressed: () => navigateTo(context, CheckOut()),
                          icon: Icon(Ionicons.cart),
                        ),
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
                          prefixIcon: Icon(Ionicons.search),
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
                                  Icon(Ionicons.arrow_forward_outline)
                                ],
                              ),
                            ],
                          ),
                          Image.asset(
                            'images/image.png',
                            width: 100,
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
                      buttonLables: ['All', 'T-Shirt', 'Hoodle', 'Special'],
                      buttonValues: ['All', 'T-Shirt', 'Hoodle', 'Special'],
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
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 30,
                        childAspectRatio: 0.58,
                      ),
                      itemCount: cubit.productInfo.length,
                      itemBuilder: (context, index) {
                        final product = cubit.productInfo[index];
                        final model = cubit.getFavourite.firstWhere(
                              (favourite) => favourite?.productTittle == product.title,
                          orElse: () => FavouriteModel(isFavourite: false),
                        );
                        return ItemCard(product, context, model!);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget ItemCard(ProductModel product, BuildContext context, FavouriteModel model) {
  return GestureDetector(
    onTap: () {
      navigateTo(context, ProductDetails(product: product));
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage('${product.image}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      PrentaCubit.get(context).setFavouriteItems(product: product);
                    },
                    icon: Icon(
                      model.isFavourite! ? Ionicons.heart : Ionicons.heart_outline,
                      color: model.isFavourite! ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -25,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Ionicons.cart,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${product.title}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Text(
                '${product.price}',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '${product.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
