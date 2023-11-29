part of 'customer_bloc.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

final class CustomerInitial extends CustomerState {}

final class CustomerLoading extends CustomerState {}

final class CustomerSuccess<T> extends CustomerState {
  final T data;
  const CustomerSuccess(this.data);
}

final class CustomerError extends CustomerState {
  final String message;
  const CustomerError(this.message);
  @override
  List<Object> get props => [message];
}
