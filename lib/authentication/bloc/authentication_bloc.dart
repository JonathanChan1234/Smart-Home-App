import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequest>(_onLogoutRequest);
    _authenticationStatusSubscription = _authRepository.status
        .listen((status) => add(AuthenticationStatusChanged(status: status)));
  }

  final AuthRepository _authRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.authenticated:
        final user = await _authRepository.getCurrentUser();
        if (user == null) return emit(const AuthenticationState.unknown());
        return emit(AuthenticationState.authenticated(user));
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  Future<void> _onLogoutRequest(
    AuthenticationLogoutRequest event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authRepository.logOut();
    return emit(const AuthenticationState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }
}
