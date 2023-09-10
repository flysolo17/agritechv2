part of 'view_product_bloc.dart';

sealed class ViewProductEvent extends Equatable {
  const ViewProductEvent();

  @override
  List<Object> get props => [];
}

class GetProductByIDEvent extends ViewProductEvent {
  final String id;
  const GetProductByIDEvent({required this.id});
  @override
  List<Object> get props => [id];
}
