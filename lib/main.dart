import 'package:flutter/material.dart';
import 'shared/network/local/cache_helper.dart';
import 'view/account_otp_verification/otp_verification.dart';
import 'view/account_otp_verification/verification_success.dart';
import 'view/layout/prenta_layout.dart';



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

