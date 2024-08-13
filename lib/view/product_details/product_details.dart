import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/models/product_model/product%20model.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/review_before/review_before.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;
  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit, PrentaStates>(
        listener: (context, state) {
          if (state is PrentaSaveToCartSuccessState) {
            PrentaCubit.get(context).showAddToCartDialog(context,  ModeCubit.get(context).isDark ? secondColor : firstColor);
          }
          if (state is PrentaSaveToCartErrorState) {
            showToast(context, title: 'Error',
                description: state.error,
                state: ToastColorState.error,
                icon: Ionicons.thumbs_down_outline);
          }
      },
      builder: (context, state) {
        var cubit = PrentaCubit.get(context);
        var mCubit=ModeCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Ionicons.chevron_back_outline),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: mCubit.isDark?Colors.grey[700]:Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        child: Image.network(
                          product.image ?? '',
                          fit: BoxFit.contain,
                        ),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  product.title ?? '',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 23,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  product.price ?? '',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'LE',
                                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(width: 8),
                                const Spacer(),
                                InkWell(
                                  onTap: (){
                                    navigateTo(context, ReviewBefore(productTitle: product.title.toString()));
                                  },
                                  child: const Text('Reviews',style: TextStyle(color: Colors.blue),)
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.description ?? '',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
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
                                                    boundaryMargin: const EdgeInsets.all(20),
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
                                                        Navigator.of(context).pop();
                                                      },
                                                      icon: Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.red,
                                                        ),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    const Text('You Can Zoom', style: TextStyle(color: Colors.grey)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.info_outline,color: Colors.red,),
                                      label: const Text(' '),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                CustomRadioButton(
                                  elevation: 0,
                                  margin: const EdgeInsets.symmetric(horizontal: 6.0),
                                  defaultSelected: cubit.selectedSize,
                                  radius: 5,
                                  shapeRadius: 10,
                                  enableShape: true,
                                  unSelectedBorderColor: Colors.white,
                                  absoluteZeroSpacing: false,
                                  unSelectedColor:mCubit.isDark?thirdColor: firstColor.withOpacity(0.2),
                                  buttonLables: const [
                                    'XS',
                                    'S',
                                    'M',
                                    'L',
                                    'XL',
                                  ],
                                  buttonValues: const [
                                    'XS',
                                    'S',
                                    'M',
                                    'L',
                                    'XL',
                                  ],
                                  buttonTextStyle: ButtonTextStyle(
                                      selectedColor: Colors.white,
                                      unSelectedColor: HexColor('252525'),
                                      textStyle: const TextStyle(fontSize: 14)),
                                  radioButtonValue: (value) {
                                    cubit.updateSize(value.toString());
                                  },
                                  height: 50,
                                  width: 50,
                                  selectedColor: HexColor('27374D'),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Colors Available:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(cubit.circleColors.length, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          cubit.updateColor(index);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: cubit.selectedCircle == index ? 2.0 : 1.0,
                                              color: cubit.selectedCircle == index ? Colors.black :Colors.black45,
                                            ),
                                            color: cubit.circleColors[index],
                                          ),
                                          child: Center(
                                            child: cubit.selectedCircle == index
                                                ? Icon(Icons.check, color: cubit.circleColors[index] == Colors.white ? Colors.black : Colors.white)
                                                : Container(),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Center(
                                  child: defaultMaterialButton(
                                    Function: () {
                                      String selectedColorName = cubit.colorNames[cubit.selectedCircle];
                                      cubit.saveToCart(
                                        color: selectedColorName,
                                        price: product.price ?? '',
                                        size: cubit.selectedSize,
                                        title: product.title ?? '',
                                        description: product.description ?? '',
                                        image: product.image ?? '',
                                          status: 'OnProcessing'
                                      );
                                      },
                                    text: 'Add To Cart',
                                  ),
                                ),
                                const SizedBox(height: 15),
                                if(state is PrentaSaveToCartLoadingState) const LinearProgressIndicator(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
