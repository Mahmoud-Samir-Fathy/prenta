import '../../models/home_model/product model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<Product> products;

  HomeSuccessState(this.products);
}

class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState(this.error);
}