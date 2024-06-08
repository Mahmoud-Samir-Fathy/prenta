import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/home_model/get product.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductRepository _productRepository;

  HomeCubit(this._productRepository) : super(HomeInitialState());
static HomeCubit get(context)=> BlocProvider.of(context);
  Future<void> fetchProducts() async {
    emit(HomeLoadingState());
    try {
      final products = await _productRepository.fetchProducts();
      emit(HomeSuccessState(products));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}