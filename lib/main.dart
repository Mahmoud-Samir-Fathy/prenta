import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printa/shared/bloc_observer/bloc_observer.dart';
import 'package:printa/shared/styles/themes.dart';
import 'package:printa/view/homeScreen/home_Cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import 'firebase_options.dart';
import 'models/home_model/get product.dart';
import 'shared/components/constants.dart';
import 'shared/network/local/cache_helper.dart';
import 'view/Splashscreen/Splash_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  uId = CacheHelper.getData(key: 'uId');
  print(uId);
  bool? onBoarding = CacheHelper.getData(key: 'OnBoarding');
  bool? isDark=CacheHelper.getData(key:'isDark');

  runApp(MyApp(
    onBoarding: onBoarding,
    uId: uId,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final bool? onBoarding;
  final String? uId;
  final bool? isDark;
  MyApp({this.onBoarding, this.uId, this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>PrentaCubit()..getUserData()..changeMode(fromShared:  isDark)),
        BlocProvider(create: (context) => HomeCubit(ProductRepository())..fetchProducts(),),
      ],
      child: BlocConsumer<PrentaCubit,PrentaStates>(
        listener: (BuildContext context, PrentaStates state){},
        builder: (BuildContext context, PrentaStates state){
          return
            MaterialApp(
                theme: lightMode,
                darkTheme: darkMode,
                debugShowCheckedModeBanner: false,
                themeMode: PrentaCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
                home: SplashScreen(onBoarding: onBoarding, uId: uId,  isDark:isDark)
            );
        },
      ),
    );
  }
}
