abstract class LoginStates{}
class LoginInitialState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{
  final String uId;
  LoginSuccessState(this.uId);
}
class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error);
}
class ChangePassVisibility extends LoginStates{}

class UpdateUserPasswordSuccessState extends LoginStates{}
class UpdateUserPasswordErrorState extends LoginStates{}
class NotificationTokenReceived extends LoginStates {
  final String token;

  NotificationTokenReceived(this.token);
}
