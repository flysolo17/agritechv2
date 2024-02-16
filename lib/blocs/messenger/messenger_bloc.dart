import 'dart:async';

import 'package:agritechv2/repository/message_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/messages.dart';

part 'messenger_event.dart';
part 'messenger_state.dart';

class MessengerBloc extends Bloc<MessengerEvent, MessengerState> {
  MessagesRepository _messagesRepository;

  final _messengerContoller = StreamController<List<Messenger>>();
  Stream<List<Messenger>> get messengerStream => _messengerContoller.stream;
  late StreamSubscription<List<Messenger>> _streamSubscription;
  MessengerBloc(
      {required MessagesRepository messagesRepository, required String myID})
      : _messagesRepository = messagesRepository,
        super(MessengerInitial()) {
    on<MessengerEvent>((event, emit) {});
    on<SendMessage>(_onSendMessage);
    _initializeStream(myID);
  }

  void _onSendMessage(SendMessage event, Emitter<MessengerState> emit) {
    try {
      emit(MessengerStateLoadingState());
      _messagesRepository.sendMessage(event.messenger);
      emit(const MessengerStateSuccessState<String>("Message sent!"));
    } catch (e) {
      emit(MessengerStateErrorState(e.toString()));
    }
  }

  void _initializeStream(String customerID) async {
    try {
      _streamSubscription =
          _messagesRepository.getMyMessages(customerID).listen((event) {
        print("Message Stream :  ${event.length}");
        _messengerContoller.add(event);
      });
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    _streamSubscription.cancel();
    _messengerContoller.close();
  }
}
