import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printa/models/home_model/get%20product.dart';
import '../../models/home_model/product model.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

abstract class ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductLoading()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await _productRepository.fetchProducts();
        emit(ProductLoaded(products));
      } catch (_) {
        emit(ProductLoading());
      }
    });
  }
}
