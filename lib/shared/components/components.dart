import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:printa/shared/styles/colors.dart';

Widget defaultTextFormField({
  required TextEditingController? controller,
  required TextInputType? KeyboardType,
  Function(String)? onChanged,
  Function(String)? onSubmit,
  VoidCallback?onTap,
  required String? Function(String?)? validate,
  required String? lable,
  required IconData? prefix,
  bool isPassword = false,
  IconData? suffix,
  Function()? suffixpressed,
})=>Container(
  width: double.infinity,
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.grey.withOpacity(0.5), // Change this color to the desired border color
      width: 0.4, // You can adjust the width of the border as needed
    ),
    color: Colors.white,
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ),
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      keyboardType: KeyboardType,
      obscureText: isPassword,
      onChanged:onChanged,
      onFieldSubmitted:onSubmit,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(prefix),
        hintText: lable,
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0),borderSide: BorderSide.none),
        suffixIcon: suffix !=null?IconButton(icon: Icon(suffix),onPressed: suffixpressed,):null,
        contentPadding: EdgeInsets.symmetric(vertical: 11.0),

      ),
      style: TextStyle(fontSize: 14),
    ),
  ),
);

Widget defaultMaterialButton({
  required String text,
  required Function,
})=>MaterialButton(
onPressed: Function,
child:
Padding(
padding: const EdgeInsets.all(12.0),
child: Text(text,style: TextStyle(color: Colors.white,fontSize: 20),),
),
color: firstColor,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.all( Radius.circular(10),),
),
);

void navigateTo(context,widget){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>widget));
}
void navigateAndFinish(context,widget){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>widget), (route) => false);
}
void showToast(context,{
  required String title,
  required String description,
  required ToastColorState state,
  required IconData icon,

})=> MotionToast(
  icon: icon,
  title: Text(title),
  description: Text(description,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
  animationType: AnimationType.fromBottom,
  animationCurve: Curves.decelerate,
  primaryColor: chooseToastColor(state),
  dismissable: true,
).show(context);

enum ToastColorState{success,error,warning}

Color chooseToastColor(ToastColorState state){
  Color color;
  switch (state)
  {
    case ToastColorState.success:
      color=Colors.green;
      break;
    case ToastColorState.error:
      color=Colors.red;
      break;
    case ToastColorState.warning:
      color=Colors.amber;
      break;
  }
  return color;
}