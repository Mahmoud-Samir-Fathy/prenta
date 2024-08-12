import 'package:printa/models/favourite_model/favourite_model.dart';
import 'package:printa/models/notification_model/notification_model.dart';
import 'package:printa/models/product_model/product%20model.dart';
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

class UpdateUserInfoLoadingState extends PrentaStates{}
class UpdateUserInfoErrorState extends PrentaStates{}
class UpdateUserInfoSuccessState extends PrentaStates{}
class UpdateUserPasswordErrorState extends PrentaStates{}
class UpdateUserAddressSuccessState extends PrentaStates{}
class UpdateUserAddressErrorState extends PrentaStates{}

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


class PrentaSaveToCartLoadingState extends PrentaStates{}
class PrentaSaveToCartSuccessState extends PrentaStates{}
class PrentaSaveToCartErrorState extends PrentaStates{
  final String error;

  PrentaSaveToCartErrorState(this.error);
}

class CartLoadedState extends PrentaStates{}
class PrentaUpdateCartSuccessState extends PrentaStates{}

class CartCheckedOutState extends PrentaStates{}
class CartCheckoutErrorState extends PrentaStates{}

class GetFrontDesignPickedSuccessState extends PrentaStates{}
class GetFrontDesignPickedErrorState extends PrentaStates{}
class UploadFrontDesignPickedSuccessState extends PrentaStates{}
class UploadFrontDesignPickedErrorState extends PrentaStates{}

class GetBackDesignPickedSuccessState extends PrentaStates{}
class GetBackDesignPickedErrorState extends PrentaStates{}
class UploadBackDesignPickedSuccessState extends PrentaStates{}
class UploadBackDesignPickedErrorState extends PrentaStates{}

class CartUpdatedState extends PrentaStates{}
class CartUpdateErrorState extends PrentaStates{}

class PrentaGetOnProcessingItemsLoadingState extends PrentaStates{}
class PrentaGetOnProcessingItemsSuccessState extends PrentaStates {
  final List<Map<String, dynamic>> items;

  PrentaGetOnProcessingItemsSuccessState(this.items);
}
class PrentaGetOnProcessingItemsErrorState extends PrentaStates {
  final String error;

  PrentaGetOnProcessingItemsErrorState(this.error);
}

class PrentaGetCancelledItemsLoadingState extends PrentaStates{}
class PrentaGetCancelledItemsSuccessState extends PrentaStates {
  final List<Map<String, dynamic>> items;

  PrentaGetCancelledItemsSuccessState(this.items);
}
class PrentaGetCancelledItemsErrorState extends PrentaStates {
  final String error;

  PrentaGetCancelledItemsErrorState(this.error);
}

class PrentaGetCompletedItemsLoadingState extends PrentaStates{}
class PrentaGetCompletedItemsSuccessState extends PrentaStates {
  final List<Map<String, dynamic>> items;

  PrentaGetCompletedItemsSuccessState(this.items);
}
class PrentaGetCompletedItemsErrorState extends PrentaStates {
  final String error;

  PrentaGetCompletedItemsErrorState(this.error);
}

class PrentaUpdateStatusSuccessState extends PrentaStates {}
class PrentaUpdateStatusErrorState extends PrentaStates {
  final String error;

  PrentaUpdateStatusErrorState(this.error);
}

class PrentaRatingUpdated extends PrentaStates {
  final double rating;

  PrentaRatingUpdated({required this.rating});
}
class PrentaReviewPosted extends PrentaStates {
  final String review;

  PrentaReviewPosted({required this.review});
}
class PrentaSendReviewSuccessState extends PrentaStates {}
class PrentaSendReviewErrorState extends PrentaStates {
  final String error;

  PrentaSendReviewErrorState(this.error);
}

class PrentaGetReviewLoadingState extends PrentaStates {}
class PrentaGetReviewSuccessState extends PrentaStates {}
class PrentaGetReviewErrorState extends PrentaStates {
  final String error;

  PrentaGetReviewErrorState(this.error);
}

class PrentaSendFavouriteItemSuccessState extends PrentaStates {}
class PrentaSendFavouriteItemErrorState extends PrentaStates {
  final String error;

  PrentaSendFavouriteItemErrorState(this.error);
}
class PrentaDeleteFavouriteItemSuccessState extends PrentaStates {}

class PrentaDeleteFavouriteItemErrorState extends PrentaStates {
  final String error;

  PrentaDeleteFavouriteItemErrorState(this.error);
}
class PrentaGetFavouriteItemSuccessState extends PrentaStates {
  final List<FavouriteModel?> getFavourite=[];
  PrentaGetFavouriteItemSuccessState();
}
class PrentaGetFavouriteItemErrorState extends PrentaStates {
  final String error;

  PrentaGetFavouriteItemErrorState(this.error);
}

class PrentaGetNotificationSuccessState extends PrentaStates {
  final List <NotificationModel> notificationModel;
  PrentaGetNotificationSuccessState(this.notificationModel);

}
class PrentaGetNotificationErrorState extends PrentaStates {
  final String error;

  PrentaGetNotificationErrorState(this.error);
}

class SearchResultsUpdated extends PrentaStates {}
class SearchCleared extends PrentaStates {}