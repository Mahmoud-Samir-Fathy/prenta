import 'package:printa/shared/components/components.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';

import '../network/local/cache_helper.dart';

void signout(context){

  CacheHelper.removeData(key: 'uId').then((value) {
    if(value) {
      navigateAndFinish(context, account_screen());
    };
  });
}

void printFullText(String text){
  final pattern=RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=> print(match.group(0)));
}


String? uId;