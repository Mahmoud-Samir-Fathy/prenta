abstract class PrentaStates{}
class PrentaInitialState extends PrentaStates{}
class PrentaLoadingState extends PrentaStates{}
class PrentaGetUserSuccessState extends PrentaStates{}
class PrentaGetUserErrorState extends PrentaStates{
  final String error;
  PrentaGetUserErrorState(this.error);
}
