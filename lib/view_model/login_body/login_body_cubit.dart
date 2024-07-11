import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/view_model/login_body/login_body_states.dart';

import '../../shared/components/components.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit():super(LoginInitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);

  IconData suffixIcon=Ionicons.eye_off_outline;
  bool isPasswordShown=true;
  void ChangePasswordVisibility(){
    isPasswordShown =!isPasswordShown;
    suffixIcon=isPasswordShown?Ionicons.eye_off_outline:Ionicons.eye_off_outline;
    emit(ChangePassVisibility());
  }

void UserLogin({
    required String email,
    required String password,
}){
      emit(LoginLoadingState());
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password).then((value) {
            emit(LoginSuccessState(value.user!.uid));
      }).catchError((error){
        emit(LoginErrorState(error.toString()));
      });
}

  Future<void> resetPassword({
    required String email,
    required BuildContext context
      })async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showToast(context, title: 'Success', description: 'Check your email', state: ToastColorState.success, icon: Ionicons.thumbs_up_outline);

    } on FirebaseAuthException catch(e){
      showToast(context, title: 'Error', description: e.toString(), state: ToastColorState.error, icon: Ionicons.thumbs_down_outline);

    }
    }


}