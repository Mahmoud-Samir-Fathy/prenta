import 'package:flutter/material.dart';
import 'package:printa/view/edit_user_profile/edit_user_profile.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';
import 'package:printa/view/login&register_screen/register_body/register_body.dart';
import 'package:printa/view/on_boarding/on_boarding.dart';
import 'package:printa/view/review_before/review_before.dart';
import 'package:printa/view/user_profile/profile.dart';
import 'shared/network/local/cache_helper.dart';
import 'view/Customize/customize.dart';
import 'view/account_otp_verification/otp_verification.dart';
import 'view/account_otp_verification/verification_success.dart';
import 'view/change_password/change_password.dart';
import 'view/edit_address/edit_address.dart';
import 'view/layout/prenta_layout.dart';
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
      home: prenta_layout()
    );
  }
}

