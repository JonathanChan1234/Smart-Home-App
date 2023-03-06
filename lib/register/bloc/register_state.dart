part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.requestError = '',
  });

  final FormzStatus status;
  final Email email;
  final Username username;
  final Password password;
  final ConfirmPassword confirmPassword;
  final String requestError;

  RegisterState copyWith({
    FormzStatus? status,
    Email? email,
    Username? username,
    Password? password,
    ConfirmPassword? confirmPassword,
    String? requestError,
  }) {
    return RegisterState(
      status: status ?? this.status,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props =>
      [status, email, username, password, confirmPassword];
}
