import 'package:printa/models/home_model/product%20model.dart';
import 'package:printa/models/user_model/user_model.dart';

abstract class PrentaStates{}
class PrentaInitialState extends PrentaStates{}

class ChangeCurrentPasswordVisibility extends PrentaStates{}

class PrentaChangeBottomNav extends PrentaStates{}
class PrentaLoadingState extends PrentaStates{}
class PrentaGetUserSuccessState extends PrentaStates{
  final UserModel userModel;

  PrentaGetUserSuccessState(this.userModel);}
class PrentaGetUserErrorState extends PrentaStates{
  final String error;
  PrentaGetUserErrorState(this.error);
}
class GetProfileImagePickedSuccessState extends PrentaStates{}
class GetProfileImagePickedErrorState extends PrentaStates{}

class UploadProfileImageSuccessState extends PrentaStates{}
class UploadProfileImageErrorState extends PrentaStates{}

class UpdateUserInfoErrorState extends PrentaStates{}
class UpdateUserInfoSuccessState extends PrentaStates{}

class UpdateUserInfoLoadingState extends PrentaStates{}


class UpdateUserPasswordErrorState extends PrentaStates{}

class UpdateUserAddressErrorState extends PrentaStates{}


class ReauthenticationSuccessState extends PrentaStates{}
class ReauthenticationErrorState extends PrentaStates{}

class ThemeBrightnessChange extends PrentaStates{}

class PrentaGetProductSuccessState extends PrentaStates {
  final List<ProductModel> products;

  PrentaGetProductSuccessState(this.products);
}
class PrentaGetProductErrorState extends PrentaStates {
  final String error;

  PrentaGetProductErrorState(this.error);
}
class PrentaSizeUpdated extends PrentaStates {}

class PrentaColorUpdated extends PrentaStates {}


class PrentaSaveToCartSuccessState extends PrentaStates{}
class PrentaSaveToCartErrorState extends PrentaStates{
  final String error;

  PrentaSaveToCartErrorState(this.error);
}
class CartLoadedState extends PrentaStates{}
class PrentaRemoveFromCartSuccessState extends PrentaStates{}
class PrentaUpdateCartSuccessState extends PrentaStates{}


class CartCheckedOutState extends PrentaStates{}
class CartCheckoutErrorState extends PrentaStates{}




