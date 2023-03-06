part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);
  const AuthenticationState.authenticated(AuthUser user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unknown() : this._();
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  final AuthenticationStatus status;
  final AuthUser? user;

  @override
  List<Object?> get props => [status, user];
}
