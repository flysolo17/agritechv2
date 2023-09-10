part of 'auth_bloc.dart';

// States
abstract class AuthState {}

class AuthenticatedState extends AuthState {
  final User? user;
  AuthenticatedState(this.user);
}

class AuthenticatedButNotVerified extends AuthState {
  final User? user;
  AuthenticatedButNotVerified(this.user);
}

class UnAthenticatedState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final User user;
  AuthSuccessState(this.user);
}

class AuthFailedState extends AuthState {
  final String errorMessage;
  AuthFailedState(this.errorMessage);
}

class AuthSaveUserState extends AuthState {
  final User user;
  final Customer users;
  AuthSaveUserState(this.user, this.users);
}
