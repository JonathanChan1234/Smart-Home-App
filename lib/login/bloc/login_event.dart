part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginFormSubmitted extends LoginEvent {
  const LoginFormSubmitted();
}
