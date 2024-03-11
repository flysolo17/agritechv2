import 'dart:async';

import 'package:agritechv2/repository/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/product/Products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<ProductEvent>((event, emit) {});
    on<GetProductByIDEvent>(_getProductByID);
    on<SearchProductEvent>(_searchProduct);
  }

  void _getProductByID(
      GetProductByIDEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      Products data = await _productRepository.getProductById(event.id);
      emit(ProductLoaded<Products>(data));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _searchProduct(
      SearchProductEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      List<Products> data = await _productRepository.searchProduct(event.name);
      emit(ProductLoaded<List<Products>>(data));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
