import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import '../../shared/components/components.dart';

class Customize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {
        if (state is PrentaSaveToCartSuccessState){
          PrentaCubit.get(context).showAddToCartDialog(context, ModeCubit.get(context).isDark ? secondColor : firstColor);
        }
        if(state is PrentaSaveToCartErrorState){
          showToast(context, title: 'Error', description: state.error, state:ToastColorState.error , icon: Ionicons.thumbs_down_outline);
        }
      },
      builder: (context, state) {
        var cubit = PrentaCubit.get(context);
        var mCubit=ModeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Ionicons.chevron_back_outline),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  height: 400,
                  width: double.infinity,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      cubit.circleColorCustomized[cubit.selectedCircleCustomized]['color'], // Extract color from map
                      BlendMode.hue,
                    ),
                    child: Container(
                      color: Colors.white,
                      child: Image.network(
                        cubit.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('300', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    SizedBox(width: 4),
                    Text('LE'),
                  ],
                ),
                SizedBox(height: 15),
                Text('Size:'),
                SizedBox(height: 10),
                CustomRadioButton(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  defaultSelected: 'M',
                  radius: 5,
                  shapeRadius: 10,
                  enableShape: true,
                  unSelectedBorderColor: Colors.white,
                  absoluteZeroSpacing: false,
                  unSelectedColor:mCubit.isDark?thirdColor: firstColor.withOpacity(0.2),
                  buttonLables: ['XS', 'S', 'M', 'L', 'XL'],
                  buttonValues: ['XS', 'S', 'M', 'L', 'XL'],
                  buttonTextStyle: ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: HexColor('252525'),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  radioButtonValue: (value) {
                    cubit.updateSize(value); // Update size in cubit
                  },
                  height: 55,
                  width: 55,
                  selectedColor: HexColor('27374D'),
                ),
                SizedBox(height: 10),
                Text('Colors available:'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(cubit.circleColorCustomized.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          cubit.setSelectedCircle(index); // Update selected color
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cubit.selectedCircleCustomized == index ? Colors.black : Colors.black45,
                              width: cubit.selectedCircleCustomized == index ? 2.0 : 1.0,
                            ),
                            color: cubit.circleColorCustomized[index]['color'], // Extract color from map
                          ),
                          child: Center(
                            child: cubit.selectedCircleCustomized == index
                                ? Icon(Icons.check, color: cubit.circleColorCustomized[index]['color'] == Colors.white ? Colors.black : Colors.white)
                                : Container(),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 10),
                Text('Insert Front Design'),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => cubit.getFrontDesignImage(),
                  child: Center(
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        color: HexColor('526D82').withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: cubit.frontDesign == null
                          ? Icon(Icons.image, color: Colors.white, size: 50)
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.file(
                          cubit.frontDesign!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text('Insert Back Design'),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => cubit.getBackDesignImage(),
                  child: Center(
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        color: HexColor('526D82').withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: cubit.backDesign == null
                          ? Icon(Icons.image, color: Colors.white, size: 50)
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.file(
                          cubit.backDesign!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: defaultMaterialButton(
                    text: 'Confirm',
                    Function: () {
                      cubit.saveCustomToCart(
                        title: 'Customized',
                        color: cubit.selectedColorName,
                        price: '300',
                        size: cubit.selectedSize,
                        image: '${cubit.imagePath}',
                        status: 'OnProcessing'
                      );

                    },
                  ),
                ),
                SizedBox(height: 15),
                if(state is PrentaSaveToCartLoadingState) LinearProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}

