part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

class CartErrorState extends CartState {
  final String error;
  const CartErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class CartLoadingState extends CartState {
  @override
  List<Object> get props => [];
}

final class CartSuccessState<T> extends CartState {
  final T data;
  const CartSuccessState(this.data);
}
