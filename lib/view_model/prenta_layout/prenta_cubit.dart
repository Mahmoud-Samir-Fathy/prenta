import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/models/favourite_model/favourite_model.dart';
import 'package:printa/models/notification_model/notification_model.dart';
import 'package:printa/models/product_model/product%20model.dart';
import 'package:printa/models/review_model/review_model.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/check_Out/checkout.dart';
import 'package:printa/view/edit_user_profile/edit_user_profile.dart';
import 'package:printa/view/layout/prenta_layout.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import 'package:uuid/uuid.dart';
import '../../models/user_model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../view/homeScreen/homescreen.dart';
import '../../view/order_status/user_orders/user_orders.dart';
import '../../view/user_profile/profile.dart';
import '../../view/wishlist/wishlist.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';



class PrentaCubit extends Cubit<PrentaStates> {
  PrentaCubit() : super(PrentaInitialState());
  static PrentaCubit get(context) => BlocProvider.of(context);

  String toCamelCase(String input) {
    return input.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).join(' ');
  }

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
    const HomeScreen(),
    const Wishlist(),
    const UserOrders(),
    const Profile()
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
  // Method to clear the temporary profile image
  void clearTempImage() {
    userImage = null;
  }

  void UploadUserImage({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    String? profileImage,
    required BuildContext context
  }) {
    emit(UpdateUserInfoLoadingState());

    if (userImage == null) {
      updateUserInfo(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
          context:context,
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
            context: context,
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
    required BuildContext context,
    String? image,
  }) {
    UserModel model = UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      profileImage: image ?? userInfo!.profileImage,
      area: userInfo!.area,
      building: userInfo!.building,
      city: userInfo!.city,
      floor: userInfo!.floor,
      streetName: userInfo!.streetName,
        isEmailAndPassword: userInfo!.isEmailAndPassword
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      navigateAndFinish(context, const PrentaLayout());
      sendPushMessage(deviceToken!, 'Information Successfully Changed', 'Personal Information', DateTime.now().toString(), 'person');
    }).catchError((error) {
      emit(UpdateUserInfoErrorState());
    });
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
        isEmailAndPassword:userInfo!.isEmailAndPassword,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      sendPushMessage(deviceToken!, 'Your Address Changed Successfully', 'Address Changed', DateTime.now().toString(), 'address');
      emit(UpdateUserAddressSuccessState());
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

  final Uuid uuid = const Uuid(); // Create an instance of Uuid

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
    required String status,
  }) {
    emit(PrentaSaveToCartLoadingState());
    final uniqueId = uuid.v4(); // Generate a unique ID
    // Add the item to the cart
    cartItems.add({
      'id': uniqueId, // Add unique ID
      'color': color,
      'price': price,
      'size': size,
      'title': title,
      'description': description,
      'image': image,
      'quantity': 1,
      'status':status
    });

    // Save cart items to shared preferences
    CacheHelper.saveCartItems(cartItems);

    emit(PrentaSaveToCartSuccessState()); // Emit success state
  }

  // Load cart items on initialization
  void loadCartItems() {
    cartItems = CacheHelper.getCartItems();
    emit(CartLoadedState());
  }

  void increaseQuantity(String id) {
    var item = cartItems.firstWhere((item) => item['id'] == id);
    item['quantity']++;
    saveCartItems();
    emit(PrentaUpdateCartSuccessState());
  }

  void decreaseQuantity(String id) {
    var item = cartItems.firstWhere((item) => item['id'] == id);
    if (item['quantity'] > 1) {
      item['quantity']--;
      saveCartItems();
      emit(PrentaUpdateCartSuccessState());
    }
  }

  void removeFromCart(String itemId) {
    cartItems.removeWhere((item) => item['id'] == itemId);
    emit(CartUpdatedState()); // Notify the UI of state change
    CacheHelper.removeCartItem(itemId); // Update SharedPreferences
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

  File? frontDesign;
  File? backDesign;

  Future getFrontDesignImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      frontDesign = File(pickedFile.path);
      emit(GetFrontDesignPickedSuccessState());
    } else {
      print('No image selected.');
      emit(GetFrontDesignPickedErrorState());
    }
  }

  Future getBackDesignImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      backDesign = File(pickedFile.path);
      emit(GetBackDesignPickedSuccessState());
    } else {
      print('No image selected.');
      emit(GetBackDesignPickedErrorState());
    }
  }

  Future<String> uploadFrontDesignImage() async {
    if (frontDesign != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('Front/${Uri.file(frontDesign!.path).pathSegments.last}');
        final uploadTask = await ref.putFile(frontDesign!);
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        emit(UploadFrontDesignPickedSuccessState());
        return downloadUrl;
      } catch (e) {
        emit(UploadFrontDesignPickedErrorState());
        return '';
      }
    }
    return '';
  }

  Future<String> uploadBackDesignImage() async {
    if (backDesign != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('Back/${Uri.file(backDesign!.path).pathSegments.last}');
        final uploadTask = await ref.putFile(backDesign!);
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        emit(UploadBackDesignPickedSuccessState());
        return downloadUrl;
      } catch (e) {
        emit(UploadBackDesignPickedErrorState());
        return '';
      }
    }
    return '';
  }


  Future<void> saveCustomToCart({
    required String color,
    required String price,
    required String size,
    required String image,
    required String title,
    required String status,

  }) async {
    emit(PrentaSaveToCartLoadingState());
    final frontDesignUrl = await uploadFrontDesignImage();
    final backDesignUrl = await uploadBackDesignImage();
    final uniqueId = uuid.v4();

    cartItems.add({
      'id': uniqueId,
      'color': color,
      'price': price,
      'size': size,
      'title': title,
      'image': image,
      'quantity': 1,
      'frontDesign': frontDesignUrl,
      'backDesign': backDesignUrl,
      'status':status
    });

    // Save cart items to shared preferences
    CacheHelper.saveCartItems(cartItems);
    frontDesign = null;
    backDesign = null;
    emit(PrentaSaveToCartSuccessState());
  }

  final List<Map<String, dynamic>> circleColorCustomized = [
    {'color': HexColor('#FFFFFF'), 'name': 'White'},
    {'color': Colors.black, 'name': 'Black'},
    {'color': HexColor('012639'), 'name': 'navy'},
    {'color': Colors.red, 'name': 'Red'},
    {'color': Colors.blue, 'name': 'Blue'},
    {'color': Colors.yellow, 'name': 'Yellow'},
    {'color': Colors.green, 'name': 'Green'},
  ];

  int selectedCircleCustomized = 0;
  String selectedColorName = 'White'; // Default color name
  String imagePath = "https://img.freepik.com/premium-psd/back-white-tee-mockup-whit-no-design-no-hanger-transparency-background-psd_693425-20997.jpg?w=740"; // Default image path

  void setSelectedCircle(int index) {
    selectedCircleCustomized = index;
    selectedColorName = circleColorCustomized[index]['name'];

    // Change image based on selected color
    if (index == 0) {
      imagePath = "https://img.freepik.com/premium-psd/back-white-tee-mockup-whit-no-design-no-hanger-transparency-background-psd_693425-20997.jpg?w=740"; // Image for the first color
    } else {
      imagePath = "https://toppng.com/uploads/preview/red-shirt-11551060979gouxt0a87n.png"; // Default image for other selections
    }

    emit(PrentaColorUpdated());
  }

  void showAddToCartDialog(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(
            alignment: AlignmentDirectional.center,
            child: Text('Successfully add to cart'),
          ),
          content: Container(
            height: 100,
            child: const Center(
              child: Text(
                'Do you want to go to checkout screen or continue browsing?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ),
          actions: [
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: ModeCubit.get(context).isDark?Colors.grey[700]:Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: firstColor),
              ),
              child: MaterialButton(
                height: 50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  navigateTo(context, const CheckOut());

                },
                child: const Text('Checkout'),
              ),
            ),
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color),
              ),
              child: MaterialButton(
                color: color,
                height: 50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  navigateTo(context, const PrentaLayout());
                },
                child: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showCheckOutDialog(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(
            alignment: AlignmentDirectional.center,
            child: Text('Warning'),
          ),
          content: Container(
            height: 100,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Please Check your information before forther go on!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'Your Address is '+'${userInfo!.city}'+','+'${userInfo!.area}'+','+'${userInfo!.streetName}'+','+'${userInfo!.building}'+','+'${userInfo!.floor}' ,maxLines: 2,overflow:TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'Your PhoneNumber is '+'${userInfo!.phoneNumber}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: firstColor),
                color: ModeCubit.get(context).isDark?Colors.grey[700]:Colors.white,

              ),
              child: MaterialButton(
                height: 50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  navigateTo(context, EditUserProfile());

                },
                child: const Text('Edit Profile'),
              ),
            ),
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color),
              ),
              child: MaterialButton(
                color: color,
                height: 50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  checkout();
                  Navigator.pop(context);
                  getOnProcessingItems();
                },
                child: const Text(
                  'ChickOut',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> onProcessingItems = [];
  Future<void> getOnProcessingItems() async {
    try {
      emit(PrentaGetOnProcessingItemsLoadingState());

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        emit(PrentaGetUserErrorState('No user logged in'));
        return;
      }

      String userId = user.uid;

      QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      onProcessingItems.clear();

      for (QueryDocumentSnapshot<Map<String, dynamic>> orderDoc in ordersSnapshot.docs) {
        var data = orderDoc.data();
        if (data.containsKey('items')) {
          var itemsField = data['items'];
          List<dynamic> cartItems;
          if (itemsField is String) {
            cartItems = jsonDecode(itemsField);
          } else {
            cartItems = itemsField;
          }
          for (var item in cartItems) {
            if (item is Map<String, dynamic> && item['status'] == 'OnProcessing') {
              onProcessingItems.add(item);
            }
          }
        } else {
          print('Order document does not contain a valid items list: $data');
        }
      }

      emit(PrentaGetOnProcessingItemsSuccessState(onProcessingItems));
    } catch (e) {
      print('Error fetching onProcessing items: $e');
      emit(PrentaGetOnProcessingItemsErrorState(e.toString()));
    }
  }

  List<Map<String, dynamic>> cancelledItems = [];
  Future<void> getCancelledItems() async {
    try {
      emit(PrentaGetCancelledItemsLoadingState());

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        emit(PrentaGetUserErrorState('No user logged in'));
        return;
      }

      String userId = user.uid;

      QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      cancelledItems.clear();

      for (QueryDocumentSnapshot<Map<String, dynamic>> orderDoc in ordersSnapshot.docs) {
        var data = orderDoc.data();
        if (data.containsKey('items')) {
          var itemsField = data['items'];
          List<dynamic> cartItems;
          if (itemsField is String) {
            cartItems = jsonDecode(itemsField);
          } else {
            cartItems = itemsField;
          }
          for (var item in cartItems) {
            if (item is Map<String, dynamic> && item['status'] == 'Cancelled') {
              cancelledItems.add(item);
            }
          }
        } else {
          print('Order document does not contain a valid items list: $data');
        }
      }

      emit(PrentaGetCancelledItemsSuccessState(cancelledItems));
    } catch (e) {
      print('Error fetching onProcessing items: $e');
      emit(PrentaGetCancelledItemsErrorState(e.toString()));
    }
  }

  List<Map<String, dynamic>> completedItems = [];
  Future<void> getCompletedItems() async {
    try {
      emit(PrentaGetCompletedItemsLoadingState());

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        emit(PrentaGetUserErrorState('No user logged in'));
        return;
      }

      String userId = user.uid;

      QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      completedItems.clear();

      for (QueryDocumentSnapshot<Map<String, dynamic>> orderDoc in ordersSnapshot.docs) {
        var data = orderDoc.data();
        if (data.containsKey('items')) {
          var itemsField = data['items'];
          List<dynamic> cartItems;
          if (itemsField is String) {
            cartItems = jsonDecode(itemsField);
          } else {
            cartItems = itemsField;
          }
          for (var item in cartItems) {
            if (item is Map<String, dynamic> && item['status'] == 'Completed') {
              completedItems.add(item);
            }
          }
        } else {
          print('Order document does not contain a valid items list: $data');
        }
      }

      emit(PrentaGetCompletedItemsSuccessState(completedItems));
    } catch (e) {
      print('Error fetching onProcessing items: $e');
      emit(PrentaGetCompletedItemsErrorState(e.toString()));
    }
  }

  void updateStatusToCancelled(String itemId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(PrentaGetUserErrorState('No user logged in'));
        return;
      }

      String userId = user.uid;

      // Retrieve the specific order document containing the item to update
      QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> orderDoc in ordersSnapshot.docs) {
        var data = orderDoc.data();
        if (data.containsKey('items')) {
          var itemsField = data['items'];
          List<dynamic> cartItems;
          if (itemsField is String) {
            cartItems = jsonDecode(itemsField);
          } else {
            cartItems = itemsField;
          }

          // Find the specific item by itemId and update its status
          bool itemUpdated = false;
          for (var item in cartItems) {
            if (item is Map<String, dynamic> && item['id'] == itemId && item['status'] == 'OnProcessing') {
              item['status'] = 'Cancelled';
              itemUpdated = true;
              break; // Exit loop once item is found and updated
            }
          }

          if (itemUpdated) {
            // Update Firestore with the modified items list for this order
            await orderDoc.reference.update({
              'items': jsonEncode(cartItems),
            });
            getOnProcessingItems();
            getCancelledItems();
            // Emit success state if update was successful
            emit(PrentaUpdateStatusSuccessState());
            return;
          }
        }
      }
      emit(PrentaUpdateStatusErrorState('Item not found or status already completed'));
    } catch (e) {
      emit(PrentaUpdateStatusErrorState('Error updating item status: $e'));
    }
  }


  void updateStatusToOnProcessing(String itemId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(PrentaGetUserErrorState('No user logged in'));
        return;
      }

      String userId = user.uid;

      // Retrieve the specific order document containing the item to update
      QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> orderDoc in ordersSnapshot.docs) {
        var data = orderDoc.data();
        if (data.containsKey('items')) {
          var itemsField = data['items'];
          List<dynamic> cartItems;
          if (itemsField is String) {
            cartItems = jsonDecode(itemsField);
          } else {
            cartItems = itemsField;
          }

          // Find the specific item by itemId and update its status
          bool itemUpdated = false;
          for (var item in cartItems) {
            if (item is Map<String, dynamic> && item['id'] == itemId && item['status'] == 'Cancelled') {
              item['status'] = 'OnProcessing';
              itemUpdated = true;
              break; // Exit loop once item is found and updated
            }
          }

          if (itemUpdated) {
            // Update Firestore with the modified items list for this order
            await orderDoc.reference.update({
              'items': jsonEncode(cartItems),
            });
            getOnProcessingItems();
            getCancelledItems();
            // Emit success state if update was successful
            emit(PrentaUpdateStatusSuccessState());
            return;
          }
        }
      }
      emit(PrentaUpdateStatusErrorState('Item not found or status already completed'));
    } catch (e) {
      emit(PrentaUpdateStatusErrorState('Error updating item status: $e'));
    }
  }



  void showCancelledOrderDialog(BuildContext context, Color color, item,title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(
            alignment: AlignmentDirectional.center,
            child: Text('Warning'),
          ),
          content: Container(
            height: 100,
            child: const Center(
              child: Text(
                'Are your sure you want to cancel order ?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ),
          actions: [
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: ModeCubit.get(context).isDark?Colors.grey[700]:Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: firstColor),
              ),
              child: MaterialButton(
                height: 50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
            ),
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color),
              ),
              child: MaterialButton(
                color: color,
                height: 50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  updateStatusToCancelled(item);
                  Navigator.pop(context);
                 sendPushMessage(deviceToken!, 'order '+ title +' has been successfully cancelled', 'Order Cancelled', DateTime.now().toString(), 'cancelled');

                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showReorderOrderDialog(BuildContext context, Color color,item,title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(
            alignment: AlignmentDirectional.center,
            child: Text('Warning'),
          ),
          content: Container(
            height: 100,
            child: const Center(
              child: Text(
                'Are you sure you want to re-order this product with the same specification?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ),
          actions: [
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: ModeCubit.get(context).isDark?Colors.grey[700]:Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: firstColor),
              ),
              child: MaterialButton(
                height: 50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
            ),
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color),
              ),
              child: MaterialButton(
                color: color,
                height: 50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  updateStatusToOnProcessing(item);
                  Navigator.pop(context);
                  sendPushMessage(deviceToken!, 'order '+ title +' has been successfully Add', 'Order Successfully add', DateTime.now().toString(), 'cancelled');


                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  double rate=0;
  void updateRating(double rating) {
    this.rate = rating;
    emit(PrentaRatingUpdated(rating: rating));
  }
  void postReview(String review) {
    emit(PrentaReviewPosted(review: review));
  }

  void sendProductReview({
    required double stars,
    required String review,
    required String price,
    required String size,
    required String image,
    required String description,
    required String title,
    required BuildContext? context,
  }) {
    ReviewModel model = ReviewModel(
      review: review,
      stars: stars,
      price: price,
      firstName: userInfo!.firstName,
      lastName: userInfo!.lastName,
      productDescription: description,
      productImage: image,
      productTitle: title,
      id: uId,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('review')
        .doc()
        .set(model.toMap())
        .then((value) {
          showToast(context, title: 'Successfully sent', description: 'Now you can see your review in product details screen', state: ToastColorState.success, icon: Ionicons.thumbs_up_outline);
      emit(PrentaSendReviewSuccessState());
          sendPushMessage(deviceToken!, 'Check your Review if you wanna', 'Review Submitted', DateTime.now().toString(), 'review');

    }).catchError((error) {
      showToast(context, title: 'Error', description: error.toString(), state: ToastColorState.error, icon: Ionicons.thumbs_down_outline);

      emit(PrentaSendReviewErrorState(error.toString()));
    });
  }

  List<ReviewModel> reviewModel = [];

  void getReview(String productTitle) {
    emit(PrentaGetReviewLoadingState());

    List<ReviewModel> allReviews = [];

    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((userSnapshot) {
      final userFetches = userSnapshot.docs.map((userDoc) {
        return userDoc.reference.collection('review').where('productTitle', isEqualTo: productTitle).get().then((reviewSnapshot) {
          final userReviews = reviewSnapshot.docs
              .map((reviewDoc) => ReviewModel.fromJason(reviewDoc.data()))
              .toList();
          allReviews.addAll(userReviews);
        });
      });

      Future.wait(userFetches).then((_) {
        print('Fetched ${allReviews.length} reviews for product: $productTitle');
        reviewModel = allReviews;
        print('Review Model: $reviewModel');
        emit(PrentaGetReviewSuccessState());
      });
    }).catchError((error) {
      print('Error fetching reviews: $error');
      emit(PrentaGetReviewErrorState(error.toString()));
    });
  }


  void setFavouriteItems({required ProductModel product}) {
    final favouritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('favourite');

    // Check if the product is currently a favorite
    favouritesCollection
        .where('productTittle', isEqualTo: product.title)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Product is already a favorite, so delete it
        for (var doc in querySnapshot.docs) {
          doc.reference.delete().then((_) {
            print('Item removed from favorites');
            emit(PrentaDeleteFavouriteItemSuccessState());
            getFavouriteItems(); // Refresh the list after deleting
          }).catchError((error) {
            emit(PrentaDeleteFavouriteItemErrorState(error.toString()));
          });
        }
      } else {
        // Product is not a favorite, so add it
        FavouriteModel favouriteModel = FavouriteModel(
          isFavourite: true,
          productTittle: product.title,
          productDescription: product.description,
          productImage: product.image,
          productPrice: product.price,
        );
        favouritesCollection.add(favouriteModel.toMap()).then((_) {
          print('Item added to favorites');
          emit(PrentaSendFavouriteItemSuccessState());
          getFavouriteItems(); // Refresh the list after adding
        }).catchError((error) {
          emit(PrentaSendFavouriteItemErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      emit(PrentaSendFavouriteItemErrorState(error.toString()));
    });
  }
  List<FavouriteModel?> getFavourite = []; // Make sure this is a class-level variable
  void getFavouriteItems() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('favourite')
        .get()
        .then((querySnapshot) {
      List<FavouriteModel> updatedFavorites = [];
      for (var doc in querySnapshot.docs) {
        updatedFavorites.add(FavouriteModel.fromJason(doc.data()));
      }
      getFavourite = updatedFavorites;
      emit(PrentaGetFavouriteItemSuccessState());
    }).catchError((error) {
      emit(PrentaGetFavouriteItemErrorState(error.toString()));
    });
  }
  void deleteFavouriteItem({required FavouriteModel model}) {
    final favouritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('favourite');

    favouritesCollection.where('productTittle', isEqualTo: model.productTittle)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
      emit(PrentaDeleteFavouriteItemSuccessState());
      getFavouriteItems(); // Refresh the list after deleting
    }).catchError((error) {
      emit(PrentaDeleteFavouriteItemErrorState(error.toString()));
    });
  }



  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  void initNotifications() {
    requestPermission();
    initInfo();
  }
  void initInfo() {
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher'); // Update with your icon resource
    var iosInitialize = const DarwinInitializationSettings();
    var initializeSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null && notificationResponse.payload!.isNotEmpty) {
          // Handle notification payload
        } else {
          // Handle empty payload
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('--------------------onMessage------------------');
      print('onMessage: ${message.notification!.title}/${message.notification!.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformSpecifics = AndroidNotificationDetails(
        '2',
        'asdasdsad',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformSpecifics,
        iOS: const DarwinNotificationDetails(),
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['body'],
      );
    });
  }
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
NotificationModel? notificationModel;
  Future<void> sendPushMessage(String token, String body, String title,String date,String image) async {
    const String projectId = 'prenta-842a9';
    const String url = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
    final String keyFilePath = 'assets/service-account-file.json'; // Ensure this path matches your assets location
    if (token.isEmpty) {
      print('Invalid token');
      return;
    }
    try {
      // Load the service account JSON file from assets
      final serviceAccountJson = await rootBundle.loadString(keyFilePath);
      final accountCredentials = ServiceAccountCredentials.fromJson(
        json.decode(serviceAccountJson),
      );
      final scopes = [
        'https://www.googleapis.com/auth/firebase.messaging',
      ];

      final authClient = await clientViaServiceAccount(accountCredentials, scopes);

      final Map<String, dynamic> message = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "click_action": "android.intent.action.MAIN",
            "status": "done",
            "body": body,
            "title": title,
          },
          "android": {
            "notification": {
              "channel_id": "2",
            },
          },
        },
      };

      final response = await authClient.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {

        print('Notification sent successfully');
      } else {
        print('Failed to send notification');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      NotificationModel notificationModel=NotificationModel(
        title: title,
        body: body,
        image: image,
        date: date,
      );
      FirebaseFirestore.instance.collection('users').doc(uId).collection('notification').doc().set(notificationModel.toMap()).then((value){
        getNotificationList();
      });
    } catch (e) {
      print('Error sending push message: $e');
    }
  }
  List<NotificationModel> notificationList = [];
  void getNotificationList() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('notification')
        .get()
        .then((value) {
          notificationList=[];
      // Iterate through each document in the collection
      value.docs.forEach((doc) {
        // Access the data in the document
        Map<String, dynamic> notificationData = doc.data();
        // Convert the data to a NotificationModel instance
        NotificationModel notification = NotificationModel.fromJason(notificationData);
        // Add the instance to the list
        notificationList.add(notification);
      });
      emit(PrentaGetNotificationSuccessState(notificationList));
      // You can print the list or use it as needed
    }).catchError((error) {
      emit(PrentaGetNotificationErrorState(error.toString()));
      print('Error getting notifications: $error');
    });
  }
  List<ProductModel> searchResults = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  void searchProduct(String query) {
    searchResults = productInfo.where((product) {
      return product.title!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(SearchResultsUpdated());
  }

  void clearSearch() {
    searchController.clear();
    searchResults = [];
    emit(SearchCleared());
  }

  void requestFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

}
