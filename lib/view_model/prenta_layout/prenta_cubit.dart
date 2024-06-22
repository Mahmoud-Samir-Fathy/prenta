import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import '../../models/user_model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../view/homeScreen/homescreen.dart';
import '../../view/order_status/user_orders/user_orders.dart';
import '../../view/user_profile/profile.dart';
import '../../view/wishlist/wishlist.dart';

class PrentaCubit extends Cubit<PrentaStates> {
  PrentaCubit() : super(PrentaInitialState());
  static PrentaCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;
  var IconList=[
    Ionicons.home,
    Ionicons.bag,
    Ionicons.archive,
    Ionicons.person
  ];


  void ChangeBottomNav(int index) {
      currentIndex = index;
      emit(PrentaChangeBottomNav());

  }
  List<Widget> screens=[
    HomeScreen(),
    wishlist(),
    user_orders(),
    profile_screen()
  ];


  UserModel? userInfo;

  void getUserData() {
    emit(PrentaLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      print(value.data());
      userInfo = UserModel.fromJason(value.data()!);
      emit(PrentaGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(PrentaGetUserErrorState(error.toString()));
    });
  }

  File? userImage;
  final ImagePicker picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      userImage = File(pickedFile.path);
      emit(GetProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(GetProfileImagePickedErrorState());
    }
  }

  void UploadUserImage({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    String? profileImage,
  }) {
    if (userImage == null) {
      updateUserInfo(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
    } else {
      FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(userImage!.path).pathSegments.last}')
          .putFile(userImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          emit(UploadProfileImageSuccessState());
          updateUserInfo(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            image: value,
          );
        }).catchError((error) {
          emit(UploadProfileImageErrorState());
        });
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }
  }

  void updateUserInfo({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    String? image,
  }) {
    UserModel model = UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      profileImage: image ?? userInfo!.profileImage,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateUserInfoErrorState());
    });
  }
}
