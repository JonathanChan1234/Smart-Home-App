part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.requestError = '',
  });

  final FormzStatus status;
  final Username username;
  final Password password;
  final String requestError;

  LoginState copyWith({
    FormzStatus? status,
    Username? username,
    Password? password,
    String? requestError,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props => [status, username, password, requestError];
}
