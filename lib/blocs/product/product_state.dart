part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

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

final class ProductLoaded<T> extends ProductState {
  final T data;
  const ProductLoaded(this.data);
}
