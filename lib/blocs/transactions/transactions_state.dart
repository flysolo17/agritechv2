part of 'transactions_bloc.dart';

sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

final class TransactionsInitial extends TransactionsState {}

final class TransactionsLoadingState extends TransactionsState {}

final class TransactionsSuccessState<T> extends TransactionsState {
  final T data;
  const TransactionsSuccessState(this.data);
}

final class TransactionsFailedState extends TransactionsState {
  final String message;
  const TransactionsFailedState(this.message);
}
