import 'package:auth_api/auth_api.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:smart_home/register/models/models.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterFormSubmitted>(_onRegisterRequest);
  }

  final AuthRepository _authRepository;

  void _onUsernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        status: Formz.validate(
          [username, state.email, state.password, state.confirmPassword],
        ),
      ),
    );
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate(
            [state.username, email, state.password, state.confirmPassword]),
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate(
            [state.username, state.email, password, state.confirmPassword]),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final confirmPassword = ConfirmPassword.dirty(
      password: state.password.value,
      value: event.confirmPassword,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        status: Formz.validate(
          [state.username, state.email, state.password, confirmPassword],
        ),
      ),
    );
  }

  Future<void> _onRegisterRequest(
    RegisterFormSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.register(
        email: state.email.value,
        username: state.username.value,
        password: state.password.value,
      );
      emit(
        state.copyWith(status: FormzStatus.submissionSuccess, requestError: ''),
      );
    } on AuthBadRequestException catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          requestError: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
        ),
      );
    }
  }
}
