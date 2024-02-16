part of 'messenger_bloc.dart';

sealed class MessengerState extends Equatable {
  const MessengerState();

  @override
  List<Object> get props => [];
}

final class MessengerInitial extends MessengerState {}

class MessengerStateErrorState extends MessengerState {
  final String error;
  const MessengerStateErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class MessengerStateLoadingState extends MessengerState {
  @override
  List<Object> get props => [];
}

final class MessengerStateSuccessState<T> extends MessengerState {
  final T data;
  const MessengerStateSuccessState(this.data);
}
