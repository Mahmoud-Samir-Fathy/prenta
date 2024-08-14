import 'package:firebase_auth/firebase_auth.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';
import '../network/local/cache_helper.dart';

Future<void> signOut(context) async{
  await FirebaseAuth.instance.signOut();
  CacheHelper.removeData(key: 'uId').then((value) {
    if(value) {
      navigateAndFinish(context, const AccountScreen());
    }
  });
}
String? uId;
String? deviceToken;