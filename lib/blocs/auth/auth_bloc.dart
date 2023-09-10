import 'package:agritechv2/models/Customer.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(UnAthenticatedState()) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignInEvent>(_authSignInEvent);
    on<AuthSignUpEvent>(_authSignupEvent);
    on<AuthSavingUserEvent>(_authSavingUserEvent);
    on<AuthLogoutEvent>(_authLoggedOutEvent);
    on<AuthSendEmailVerification>(_onSendEmailVerification);
    on<AuthGetProfileEvent>(_onGetProfileEvent);
    add(AuthUserChanged(_authRepository.currentUser));
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(AuthLoadingState());
    final User? currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      if (currentUser.emailVerified) {
        emit(AuthenticatedState(currentUser));
      } else {
        emit(AuthenticatedButNotVerified(currentUser));
      }
    } else {
      emit(UnAthenticatedState());
    }
  }

  void _authSignInEvent(AuthSignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      var result = await _authRepository.login(
          email: event.email, password: event.password);
      emit(AuthSuccessState(result!));
      add(AuthUserChanged(result));
    } catch (e) {
      emit(AuthFailedState(e.toString()));
    }
  }

  void _authLoggedOutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      print("Signing out");
      await _authRepository.logout();
      add(AuthUserChanged(_authRepository.currentUser));
    } catch (e) {
      emit(AuthFailedState(e.toString()));
    }
  }

  void _authSignupEvent(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      print('Signing up....');
      var result = await _authRepository.signup(
          email: event.email, password: event.password);
      if (result != null) {
        var user = Customer(
          id: result.uid,
          profile: "",
          name: event.name,
          email: event.email,
          phone: event.phone,
        );
        print('Signing success....');
        emit(AuthSaveUserState(result, user));
      } else {
        emit(AuthFailedState('unkown error'));
      }
    } catch (e) {
      emit(AuthFailedState(e.toString()));
    }
  }

  void _authSavingUserEvent(
      AuthSavingUserEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      print('Saving user....');
      await _userRepository.createUser(event.users);
      print('Saving success...');
      add(AuthUserChanged(event.user));
    } catch (error) {
      print('Saving error...');
      emit(AuthFailedState(error.toString()));
    }
  }

  void _onSendEmailVerification(
      AuthSendEmailVerification event, Emitter<AuthState> emit) async {
    User? user = _authRepository.currentUser;
    try {
      if (user != null) {
        emit(AuthLoadingState());
        await _authRepository.sendEmailVerification(user);
        emit(AuthSuccessState(user));
      } else {
        emit(UnAthenticatedState());
      }
    } catch (e) {
      emit(AuthFailedState(e.toString()));
    }
  }

  void _onGetProfileEvent(AuthGetProfileEvent event, Emitter<AuthState> emit) {
    User? user = _authRepository.currentUser;
    try {
      if (user != null) {
        emit(AuthLoadingState());
        var result = _userRepository.getCustomer(user.uid);
        emit(AuthSuccessState(user));
      } else {
        emit(UnAthenticatedState());
      }
    } catch (e) {
      emit(AuthFailedState(e.toString()));
    }
  }
}
