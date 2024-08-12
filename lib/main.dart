import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printa/shared/bloc_observer/bloc_observer.dart';
import 'package:printa/shared/styles/themes.dart';
import 'package:printa/view/Splashscreen/Splash_Screen.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/change_mode/mode_states.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import 'firebase_options.dart';
import 'shared/components/constants.dart';
import 'shared/network/local/cache_helper.dart';
import 'view/search_screen/search_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  print('Handling a background message${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  uId = await CacheHelper.getData(key: 'uId');
  deviceToken=CacheHelper.getData(key: 'token');
  print('My Device token is ==================$deviceToken');
  print('And This my id in main ########################## ${uId}');
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
        BlocProvider(create: (context)=>PrentaCubit()..initNotifications()..userInfo),
        BlocProvider(create: (context) => ModeCubit()..changeMode(fromShared:isDark),)
      ],
      child: BlocConsumer<ModeCubit,ModeStates>(
        listener: (BuildContext context, ModeStates state){},
        builder: (BuildContext context, ModeStates state){
          return
            MaterialApp(
                theme: lightMode,
                darkTheme: darkMode,
                debugShowCheckedModeBanner: false,
                themeMode: ModeCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
                home:SplashScreen(onBoarding: onBoarding, uId: uId,  isDark:isDark)
            );
        },
      ),
    );
  }
}
