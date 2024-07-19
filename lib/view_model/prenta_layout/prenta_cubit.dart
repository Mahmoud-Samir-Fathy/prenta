import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/models/product_model/product%20model.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/check_Out/checkout.dart';
import 'package:printa/view/edit_user_profile/edit_user_profile.dart';
import 'package:printa/view/layout/prenta_layout.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import 'package:uuid/uuid.dart';
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
      area: userInfo!.area,
      building: userInfo!.building,
      city: userInfo!.city,
      floor: userInfo!.floor,
      streetName: userInfo!.streetName
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

  final Uuid uuid = Uuid(); // Create an instance of Uuid

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
          title: Align(
            alignment: AlignmentDirectional.center,
            child: Text('Successfully add to cart'),
          ),
          content: Container(
            height: 100,
            child: Center(
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
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: firstColor),
              ),
              child: MaterialButton(
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  navigateTo(context, CheckOut());

                },
                child: Text('Checkout'),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  navigateTo(context, PrentaLayout());
                },
                child: Text(
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
          title: Align(
            alignment: AlignmentDirectional.center,
            child: Text('Warning'),
          ),
          content: Container(
            height: 100,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Please Check your information before forther go on!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'Your Address is '+'${userInfo!.city}'+','+'${userInfo!.area}'+','+'${userInfo!.streetName}'+','+'${userInfo!.building}'+','+'${userInfo!.floor}' ,maxLines: 2,overflow:TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'Your PhoneNumber is '+'${userInfo!.phoneNumber}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w300),
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
              ),
              child: MaterialButton(
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  navigateTo(context, edit_profile());

                },
                child: Text('Edit Profile'),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  checkout();
                  Navigator.pop(context);
                },
                child: Text(
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
  void updateStatusToCompleted(String itemId) async {
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


  void showCancelledOrderDialog(BuildContext context, Color color, item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Align(
            alignment: AlignmentDirectional.center,
            child: Text('Warning'),
          ),
          content: Container(
            height: 100,
            child: Center(
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
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: firstColor),
              ),
              child: MaterialButton(
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onPressed: () {
                  updateStatusToCompleted(item);
                  Navigator.pop(context);
                },
                child: Text(
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
    required String color,
    required String quantity ,
     String? frontDesign,
     String? backDesign,
    required String status,
    required String id,
    required String title,

}){
    ProductModel model=ProductModel(
      review: review,
      stars: stars,
      price: price,
      size: size,
      description: description,
      color: color,
      quantity: quantity,
      frontDesign: '',
      backDesign: '',
      status: status,
      id: id,
      title: title,
      image: image

    );
    FirebaseFirestore.instance.collection('users').doc(uId).collection('review').doc().set(model.toMap()).then((value){

      emit(PrentaSendReviewSuccessState());
    }).catchError((error){
      emit(PrentaSendReviewErrorState(error.toString()));
    });
  }
}