part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetProductEvent extends ProductEvent {
  @override
  List<Object> get props => [];
}

class GetProductByIDEvent extends ProductEvent {
  final String id;
  const GetProductByIDEvent({required this.id});
  @override
  List<Object> get props => [id];
}
