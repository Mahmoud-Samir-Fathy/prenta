import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/models/favourite_model/favourite_model.dart';
import 'package:printa/models/product_model/product%20model.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/check_Out/checkout.dart';
import 'package:printa/view/notificationScreen/notificationscreen.dart';
import 'package:printa/view/product_details/product_details.dart';
import 'package:printa/view/search_screen/search_screen.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PrentaCubit.get(context);
        var mCubit=ModeCubit.get(context);

        if (cubit.productInfo.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
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
                            const Text('Welcome Back!'),
                            Text('${cubit.toCamelCase(cubit.userInfo?.firstName ?? '')} ${cubit.toCamelCase(cubit.userInfo?.lastName ?? '')}'),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => navigateTo(context, const NotificationScreen()),
                          icon: const Icon(Ionicons.notifications),
                        ),
                        IconButton(
                          onPressed: () => navigateTo(context, const CheckOut()),
                          icon: const Icon(Ionicons.cart),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: (){
                        navigateTo(context, const SearchScreen());
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Ionicons.search,color: Colors.grey,),
                            SizedBox(width: 8.0),
                            Text(
                              'What are you looking for...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
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
                    const SizedBox(height: 15),
                    CustomRadioButton(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      defaultSelected: 'All',
                      radius: 4,
                      shapeRadius: 40,
                      enableShape: true,
                      unSelectedBorderColor: Colors.white,
                      absoluteZeroSpacing: false,
                      unSelectedColor: mCubit.isDark?forthColor:HexColor('526D82').withOpacity(0.2),
                      buttonLables: const ['All', 'T-Shirt', 'Hoodle', 'Special'],
                      buttonValues: const ['All', 'T-Shirt', 'Hoodle', 'Special'],
                      buttonTextStyle: ButtonTextStyle(
                        selectedColor: Colors.white,
                        unSelectedColor: HexColor('252525'),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      radioButtonValue: (value) {
                        print(value);
                      },
                      height: 30,
                      width: 90,
                      selectedColor: HexColor('27374D'),
                    ),
                    const SizedBox(height: 15),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        return itemCard(product, context, model!);
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

Widget itemCard(ProductModel product, BuildContext context, FavouriteModel model) {
  return GestureDetector(
    onTap: () {
      navigateTo(context, ProductDetails(product: product,model:model));
    },
    child: Container(
      decoration: BoxDecoration(
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
              Positioned(
                bottom: -25,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Ionicons.cart,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${product.title}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              Text(
                '${product.price}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${product.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
