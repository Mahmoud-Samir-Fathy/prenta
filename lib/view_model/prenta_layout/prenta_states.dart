abstract class PrentaStates{}
class PrentaInitialState extends PrentaStates{}

class ChangeCurrentPasswordVisibility extends PrentaStates{}

class PrentaChangeBottomNav extends PrentaStates{}
class PrentaLoadingState extends PrentaStates{}
class PrentaGetUserSuccessState extends PrentaStates{}
class PrentaGetUserErrorState extends PrentaStates{
  final String error;
  PrentaGetUserErrorState(this.error);
}
class GetProfileImagePickedSuccessState extends PrentaStates{}
class GetProfileImagePickedErrorState extends PrentaStates{}

class UploadProfileImageSuccessState extends PrentaStates{}
class UploadProfileImageErrorState extends PrentaStates{}

class UpdateUserInfoErrorState extends PrentaStates{}
class UpdateUserPasswordErrorState extends PrentaStates{}

class UpdateUserInfoLoadingState extends PrentaStates{}


class ThemeBrightnessChange extends PrentaStates{}

