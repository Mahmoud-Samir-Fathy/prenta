import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/models/home_model/product%20model.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';
import 'package:printa/view/login&register_screen/login_body/login_body.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../shared/network/local/cache_helper.dart';
import '../../view/homeScreen/homescreen.dart';
import '../../view/order_status/user_orders/user_orders.dart';
import '../../view/user_profile/profile.dart';
import '../../view/wishlist/wishlist.dart';

class PrentaCubit extends Cubit<PrentaStates> {
  PrentaCubit() : super(PrentaInitialState());
  static PrentaCubit get(context) => BlocProvider.of(context);

  IconData suffixIcon=Ionicons.eye_off_outline;
  bool isPasswordShown=true;
  void ChangePasswordVisibility(){
    isPasswordShown =!isPasswordShown;
    suffixIcon=isPasswordShown?Ionicons.eye_off_outline:Ionicons.eye_outline;
    emit(ChangeCurrentPasswordVisibility());
  }


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
    Wishlist(),
    UserOrders(),
    Profile()
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
      emit(PrentaGetUserSuccessState(userInfo!));
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
    emit(UpdateUserInfoLoadingState());

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

  void updateUserAddress({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phoneNumber,
    String? image,
    required String streetName,
    required String area,
    required String building,
    required String city,
    required String floor,

  }) {
    UserModel model = UserModel(
      firstName: userInfo!.firstName,
      lastName:  userInfo!.lastName,
      email:  userInfo!.email,
      password: userInfo!.password,
      phoneNumber:  userInfo!.phoneNumber,
      profileImage: image ?? userInfo!.profileImage,
      streetName: streetName,
      area: area,
      building: building,
      city: city,
      floor: floor,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateUserAddressErrorState());
    });
  }

  Future<void> updateUserPassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(UpdateUserInfoLoadingState());

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Reauthenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update password in Firebase Authentication
        await user.updatePassword(newPassword);

        // Update password in Firestore
        userInfo!.password = newPassword;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(userInfo!.toMap());

        emit(UpdateUserInfoSuccessState());
      } catch (e) {
        emit(UpdateUserInfoErrorState());
      }
    } else {
      emit(UpdateUserInfoErrorState());
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
          builder: (context) => AccountScreen(fromResetPassword: true),
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

  List<ProductModel> productInfo = [];

  void getProductData() {
    emit(PrentaLoadingState());
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((querySnapshot) {
      productInfo = querySnapshot.docs
          .map((doc) => ProductModel.fromJason(doc.data() as Map<String, dynamic>))
          .toList();
      emit(PrentaGetProductSuccessState(productInfo));
    }).catchError((error) {
      print(error.toString());
      emit(PrentaGetProductErrorState(error.toString()));
    });
  }

  String selectedSize = 'M';
  int selectedCircle = 0;

  final List<Color> circleColors = [
    Colors.black,
    Colors.white,
    HexColor('012639'),
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
  ];

  final List<String> colorNames = [
    'Black',
    'White',
    'Navy',
    'Red',
    'Blue',
    'Yellow',
    'Green',
  ];
  void updateSize(String size) {
    selectedSize = size;
    emit(PrentaSizeUpdated());
  }

  void updateColor(int index) {
    selectedCircle = index;
    emit(PrentaColorUpdated());
  }

  List<Map<String, dynamic>> cartItems = [];

  void saveCartItems() {
    CacheHelper.saveListData(key: 'cartItems', value: cartItems);
  }

  // Example method to add item to cart
  void saveToCart({
    required String color,
    required String price,
    required String size,
    required String title,
    required String description,
    required String image,
  }) {
    // Add the item to the cart
    cartItems.add({
      'color': color,
      'price': price,
      'size': size,
      'title': title,
      'description': description,
      'image': image,
      'quantity': 1,
    });

    // Save cart items to shared preferences
    CacheHelper.saveCartItems(cartItems);

    emit(PrentaSaveToCartSuccessState()); // Emit success state
  }


  // Load cart items on initialization

  void loadCartItems() {
    cartItems = CacheHelper.getCartItems() ?? [];
    emit(CartLoadedState());
  }

  void increaseQuantity(String title) {
    var item = cartItems.firstWhere((item) => item['title'] == title);
    item['quantity']++;
    saveCartItems();
    emit(PrentaUpdateCartSuccessState());
  }

  void decreaseQuantity(String title) {
    var item = cartItems.firstWhere((item) => item['title'] == title);
    if (item['quantity'] > 1) {
      item['quantity']--;
      saveCartItems();
      emit(PrentaUpdateCartSuccessState());
    }

  }
  void removeFromCart(String title) {
    print("Removing item: $title");
    cartItems.removeWhere((item) => item['title'] == title);
    saveCartItems();
    CacheHelper.removeCartItem(title); // Ensure this is called
    emit(PrentaRemoveFromCartSuccessState());
  }

  double calculateTotal() {
    return cartItems.fold(0, (total, item) => total + (double.parse(item['price']) * item['quantity']));
  }

  double calculateTotalWithShipping() {
    const double shippingCost = 50.0;
    return calculateSubtotal() + shippingCost;
  }

  double calculateSubtotal() {
    return calculateTotal(); // Adjust if needed
  }
  Future<void> checkout() async {
    try {
      // Get the current user's ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        return;
      }
      String userId = user.uid;

      // Assuming cartItems is a List<Map<String, dynamic>>
      final cartItems = CacheHelper.getData(key: 'cartItems');

      if (cartItems == null || cartItems.isEmpty) {
        print('No items in the cart');
        return;
      }

      // Save cart items to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('orders').add({
        'items': cartItems,
        'total': calculateTotalWithShipping(),
        'date': Timestamp.now(),
      });

      // Clear the cart in the CacheHelper
      CacheHelper.removeData(key: 'cartItems');
      loadCartItems(); // Update the state to reflect the cleared cart
      emit(CartCheckedOutState());

      print('Checkout successful');
    } catch (e) {
      print('Error during checkout: $e');
      emit(CartCheckoutErrorState());
    }
  }
}