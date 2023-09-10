
import 'package:agritechv2/models/Products.dart';
import 'package:agritechv2/repository/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const ProductLoaded([])) {
    on<ProductEvent>((event, emit) {});
    on<GetProductEvent>(_getAllProducts);
  }
  void _getAllProducts(
      GetProductEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final data = await _productRepository.getAllProducts();
      emit(ProductLoaded(data));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
