import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/models/user_model/user_model.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/shared/network/local/cache_helper.dart';
import 'package:printa/view/layout/prenta_layout.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';
import 'package:printa/view_model/login_body/login_body_states.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import '../../shared/components/components.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit():super(LoginInitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);

  IconData suffixIcon=Ionicons.eye_off_outline;
  bool isPasswordShown=true;
  void changePasswordVisibility(){
    isPasswordShown =!isPasswordShown;
    suffixIcon=isPasswordShown?Ionicons.eye_off_outline:Ionicons.eye_off_outline;
    emit(ChangePassVisibility());
  }

void userLogin({
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


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    emit(LoginLoadingState());
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Before saving user data, check if they already exist in Firestore
          bool userExists = await checkUserInFirestore(user.uid);

          if (!userExists) {
            await saveUserDataToFirestore(user);
          }

          emit(LoginSuccessState(user.uid));
        }
      } else {
        emit(LoginErrorState('Google sign-in aborted'));
      }
    } catch (error) {
      emit(LoginErrorState(error.toString()));
    }
  }
  Future<bool> checkUserInFirestore(String uid) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return docSnapshot.exists;
    } catch (error) {
      emit(LoginErrorState('Failed to check user in Firestore: $error'));
      return false;
    }
  }

  Future<void> saveUserDataToFirestore(User user) async {
    try {
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      UserModel userModel = UserModel(
        firstName: user.displayName?.split(' ').first,
        lastName: user.displayName?.split(' ').last,
        email: user.email,
        profileImage: user.photoURL,
        streetName: '',
        floor: '',
        city: '',
        building: '',
        area: '',
        password: '',
        phoneNumber: '',
        isEmailAndPassword: false,
      );

      // Saving user data to Firestore
      await userDoc.set(userModel.toMap());
      emit(LoginSuccessState(user.uid));
    } catch (error) {
      emit(LoginErrorState('Failed to save user data: $error'));
    }
  }


  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showToast(
        context,
        title: 'Success',
        description: 'Check your email',
        state: ToastColorState.success,
        icon: Ionicons.thumbs_up_outline,
      );

      // Navigate to the login screen with the flag
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AccountScreen(fromResetPassword: true),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showToast(
        context,
        title: 'Error',
        description: e.toString(),
        state: ToastColorState.error,
        icon: Ionicons.thumbs_down_outline,
      );
    }
  }

  Future<void> loginAndUpdatePassword(
      BuildContext context,
      String email,
      String password,
      ) async {
    try {
      // Sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update the password in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'password': password})
            .then((_) {
          print('Password updated successfully in Firestore for user: ${user.uid}');
          emit(UpdateUserPasswordSuccessState());
          PrentaCubit.get(context).sendPushMessage(deviceToken!, 'Password has been updated successfully', 'Password Updated', DateTime.now().toString(), 'password');
          navigateAndFinish(context, const PrentaLayout());
          // Navigate to profile or home screen here if needed
        }).catchError((error) {
          print('Failed to update password in Firestore: $error');
          showToast(
            context,
            title: 'Error',
            description: 'Failed to update password',
            state: ToastColorState.error,
            icon:  Ionicons.thumbs_down_outline,
            // Adjust as per your toast implementation
          );
          emit(UpdateUserPasswordErrorState());

        });
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException occurred: ${e.message}');
      showToast(
        context,
        title: 'Error',
        description: e.message ?? 'Failed to login',
        state: ToastColorState.error,
        icon:  Ionicons.thumbs_down_outline,
        // Adjust as per your toast implementation
      );
      emit(UpdateUserPasswordErrorState());

    } catch (e) {
      print('Error occurred: $e');
      showToast(
        context,
        title: 'Error',
        description: 'An error occurred',
        state: ToastColorState.error,
        icon: Ionicons.thumbs_down_outline,
        // Adjust as per your toast implementation
      );
      emit(UpdateUserPasswordErrorState());

    }
  }
  void getDeviceToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      deviceToken = token;
      print('My token is $deviceToken');
      saveToken(token!);
      CacheHelper.saveData(
          key: 'token',
          value: token);
      emit(NotificationTokenReceived(token));
    }).catchError((error) {
      print('Error getting device token: $error');
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('user device token')
        .add({
      'token': token,
    });
  }
}