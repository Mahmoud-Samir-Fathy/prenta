import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

import '../../models/user_model/user_model.dart';

class PrentaCubit extends Cubit<PrentaStates>{
  PrentaCubit():super(PrentaInitialState());

  PrentaCubit get(context)=> BlocProvider.of(context);

  UserModel? model;

  void getUserData(){
    emit(PrentaLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value){
          print(value.data());
          model=UserModel.fromJason(value.data()!);
          emit(PrentaGetUserSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(PrentaGetUserErrorState(error.toString()));
    });

  }
}