import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:printa/shared/bloc_observer/bloc_observer.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';
import 'package:printa/view/on_boarding/on_boarding.dart';
import 'firebase_options.dart';
import 'shared/components/constants.dart';
import 'shared/network/local/cache_helper.dart';
import 'view/layout/prenta_layout.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  uId=CacheHelper.getData(key: 'uId');
  print(uId);
  Widget widget;

  runApp(MyApp());

  bool? onBoarding=CacheHelper.getData(key:'OnBoarding');
  if(onBoarding!=null){
    if(uId !=null) widget=prenta_layout();
    else widget=account_screen();
  }else widget=on_boarding();
  runApp(MyApp(
    // isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // final bool? isDark;
  final Widget? startWidget;
  MyApp({this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:  false,
      home: startWidget
    );
  }
}

