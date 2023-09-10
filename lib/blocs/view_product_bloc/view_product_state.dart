part of 'view_product_bloc.dart';

sealed class ViewProductState extends Equatable {
  const ViewProductState();

  @override
  List<Object> get props => [];
}

class ViewProductInitial extends ViewProductState {}

class ViewProductError extends ViewProductInitial {
  final String error;
  ViewProductError(this.error);

  @override
  List<Object> get props => [error];
}

class ViewProductLoading extends ViewProductInitial {
  @override
  List<Object> get props => [];
}

class ViewProductLoaded extends ViewProductInitial {
  final Products products;
  ViewProductLoaded(this.products);
  @override
  List<Object> get props => [products];
}
