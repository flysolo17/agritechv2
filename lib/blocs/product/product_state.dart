part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductError extends ProductState {
  final String error;
  const ProductError(this.error);

  @override
  List<Object> get props => [error];
}

class ProductLoading extends ProductState {
  @override
  List<Object> get props => [];
}

class ProductLoaded extends ProductState {
  final List<Products> products;
  const ProductLoaded(this.products);
  @override
  List<Object> get props => [products];
}
