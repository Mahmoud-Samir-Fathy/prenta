import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printa/shared/network/local/cache_helper.dart';
import 'package:printa/view_model/change_mode/mode_states.dart';

class ModeCubit extends Cubit<ModeStates>{
  ModeCubit():super(ModeInitialState());
  static ModeCubit get(context)=>BlocProvider.of(context);

  bool isDark=false;
  void changeMode({bool? fromShared}) {
    if(fromShared !=null){
      isDark=fromShared;
      emit(ThemeBrightnessChange());
    }else {
      isDark=!isDark;
      CacheHelper.putBool(key: 'isDark', value: isDark).then((value) {
        emit(ThemeBrightnessChange());
      });
    }
  }
}