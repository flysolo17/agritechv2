part of 'messenger_bloc.dart';

sealed class MessengerEvent extends Equatable {
  const MessengerEvent();
  @override
  List<Object> get props => [];
}

class SendMessage extends MessengerEvent {
  final Messenger messenger;
  const SendMessage(this.messenger);
}
