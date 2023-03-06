part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  const RegisterEmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class RegisterUsernameChanged extends RegisterEvent {
  const RegisterUsernameChanged({required this.username});
  final String username;

  @override
  List<Object> get props => [username];
}

class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  const RegisterConfirmPasswordChanged({required this.confirmPassword});

  final String confirmPassword;

  @override
  List<Object> get props => [confirmPassword];
}

class RegisterFormSubmitted extends RegisterEvent {
  const RegisterFormSubmitted();
}
