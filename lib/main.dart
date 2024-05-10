import 'package:flutter/material.dart';
import 'package:printa/view/on_boarding/on_boarding.dart';
import 'shared/network/local/cache_helper.dart';
import 'view/forget_password/change_password.dart';
import 'view/forget_password/forget_password.dart';
import 'view/forget_password/forget_password_otp.dart';
import 'view/forget_password/successful_change.dart';
import 'view/login&register_screen/account_screen/account_screen.dart';
import 'view/order_status/user_orders/user_orders.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  runApp(const MyApp());

  // bool? onBoarding=CacheHelper.getData(key:'OnBoarding');
  // if(onBoarding!=null){
  //   if(token !=null) widget=Shop_App_layout();
  //   else widget=ShopLoginScreen();
  // }else widget=On_BoardingScreen();
  runApp(MyApp(
    // isDark: isDark,
    // startWidget: widget,
  ));

}

class MyApp extends StatelessWidget {
  // final bool? isDark;
  // final Widget? startWidget;
  // MyApp({this.isDark,this.startWidget});
   const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:  false,
      home: successful_change()
    );
  }
}

