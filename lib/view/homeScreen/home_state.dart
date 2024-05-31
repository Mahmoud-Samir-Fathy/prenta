import 'package:bloc/bloc.dart';

import '../../models/home_model/get product.dart';
import 'home_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductLoading()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await _productRepository.fetchProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductLoading());
      }
    });
  }
}
