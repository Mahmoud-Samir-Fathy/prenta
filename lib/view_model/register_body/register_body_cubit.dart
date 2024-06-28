import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for PlatformException
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Flutter Bloc
import 'package:ionicons/ionicons.dart';
import 'package:printa/view_model/register_body/register_body_states.dart';
import '../../models/user_model/user_model.dart'; // Import your user model

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData suffixIcon = Ionicons.eye_off_outline;
  bool isPasswordShown = true;

  void ChangePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    suffixIcon =
    isPasswordShown ? Ionicons.eye_off_outline : Ionicons.eye_outline;
    emit(PasswordVisibilityIconChange());
  }

  void userRegister({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String uId,
  }) {
    UserModel model = UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      profileImage:
      'https://img.freepik.com/premium-vector/profile-photo-account-social-media-vector-illustration_276184-167.jpg?w=740',
      area: '',
      building: '',
      city: '',
      floor: '',
      streetName: '',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
      sendOTP(formatPhoneNumber(phoneNumber));
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }

  String? verificationID;

  void sendOTP(String formattedPhoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          verificationID = verificationId;
          emit(AuthCodeSentState());
        },
        verificationCompleted: (phoneAuthCredential) {
          signInWithPhone(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException error) {
          emit(AuthErrorState(error.message.toString()));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          verificationID = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    } on PlatformException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    } catch (e) {
      emit(AuthErrorState('Unexpected error: $e'));
    }
  }



  void verifyOTP(String otp) async {
    emit(AuthLoadingState());

    if (verificationID == null) {
      emit(AuthErrorState("Verification ID not set"));
      return;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID!,
      smsCode: otp,
    );
    signInWithPhone(credential);
  }

  void signInWithPhone(AuthCredential credential) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        emit(AuthLoggedInState());
      }
      //01098976832
    } on FirebaseAuthException catch (ex) {
      emit(AuthErrorState(ex.message.toString()));
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    String normalizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Add country code if missing and ensure it starts with '+'
    if (!normalizedPhoneNumber.startsWith('+2')) {
      normalizedPhoneNumber = '+2$normalizedPhoneNumber';
    }

    return normalizedPhoneNumber;
  }

  // String? verificationID;
  //
  // void sendOTP(String phoneNumber) async {
  //   emit(AuthLoadingState());
  //
  //   FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     codeSent: (verificationId, forceResendingToken) {
  //       verificationID = verificationId;
  //       emit(AuthCodeSentState());
  //     },
  //     verificationCompleted: (phoneAuthCredential) {
  //       signInWithPhone(phoneAuthCredential);
  //     },
  //     verificationFailed: (error) {
  //       emit(AuthErrorState(error.message.toString()));
  //     },
  //     codeAutoRetrievalTimeout: (verificationId) {
  //       verificationID = verificationId;
  //     },
  //   );
  // }
  //
  // void verifyOTP(String otp) async {
  //   emit(AuthLoadingState());
  //
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationID!, smsCode: otp);
  //   signInWithPhone(credential);
  // }
  //
  // void signInWithPhone(AuthCredential credential) async {
  //   try {
  //     UserCredential userCredential =
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //     if (userCredential.user != null) {
  //       emit(AuthLoggedInState());
  //     }
  //   } on FirebaseAuthException catch (ex) {
  //     emit(AuthErrorState(ex.message.toString()));
  //   }
  // }
}
