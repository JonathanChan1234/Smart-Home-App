part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged({required this.status});
  final AuthenticationStatus status;
}

class AuthenticationLogoutRequest extends AuthenticationEvent {}
