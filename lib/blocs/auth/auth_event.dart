part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final User? user;
  const AuthUserChanged(this.user);
  List<Object?> get props => [user];
}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInEvent(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpEvent extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String password;
  const AuthSignUpEvent(this.name, this.phone, this.email, this.password);
  @override
  List<Object?> get props => [name, phone, email, password];
}

class AuthLogoutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthSavingUserEvent extends AuthEvent {
  final User user;
  final Customer users;

  const AuthSavingUserEvent(this.user, this.users);
  @override
  List<Object?> get props => [user, users];
}

class AuthSendEmailVerification extends AuthEvent {
  const AuthSendEmailVerification();
  @override
  List<Object?> get props => [];
}

class AuthGetProfileEvent extends AuthEvent {
  const AuthGetProfileEvent();
  @override
  List<Object?> get props => [];
}
