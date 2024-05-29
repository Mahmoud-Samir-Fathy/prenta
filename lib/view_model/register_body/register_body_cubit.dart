import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/view_model/register_body/register_body_states.dart';
import '../../models/user_model/user_model.dart';

class RegisterCubit extends Cubit<RegisterStates>{
  RegisterCubit():super(RegisterInitialState());
  static RegisterCubit get(context)=> BlocProvider.of(context);

  IconData suffixIcon=Ionicons.eye_off_outline;
  bool isPasswordShown=true;

void ChangePasswordVisibility(){
  isPasswordShown=!isPasswordShown;
  suffixIcon=isPasswordShown?Ionicons.eye_off_outline:Ionicons.eye_outline;
  emit(PasswordVisibilityIconChange());
}
  void userRegister({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int phoneNumber,
  }){
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password:password,
          phoneNumber:phoneNumber,
          uId: value.user!.uid);
    }).catchError((error){
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }
  void userCreate({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int phoneNumber,

    required String uId,

  }){
    UserModel model= UserModel(
        firstName: firstName,
        lastName:lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap()).then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error){
      emit(CreateUserErrorState(error.toString()));
    });
  }
}