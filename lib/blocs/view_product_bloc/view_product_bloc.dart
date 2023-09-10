import 'package:agritechv2/models/Products.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../repository/product_repository.dart';

part 'view_product_event.dart';
part 'view_product_state.dart';

class ViewProductBloc extends Bloc<ViewProductEvent, ViewProductState> {
  final ProductRepository _productRepository;

  ViewProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ViewProductInitial()) {
    on<ViewProductEvent>((event, emit) {});
    on<GetProductByIDEvent>(_getProductByID);
  }
  void _getProductByID(
      GetProductByIDEvent event, Emitter<ViewProductState> emit) async {
    try {
      emit(ViewProductLoading());
      final data = await _productRepository.getProductById(event.id);
      emit(ViewProductLoaded(data));
    } catch (e) {
      emit(ViewProductError(e.toString()));
    }
  }
}
