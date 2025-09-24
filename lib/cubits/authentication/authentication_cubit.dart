import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kana_bus_app/barrel.dart';
import 'package:logger/logger.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthRepository _authRepository;
  final Logger _log;

  AuthenticationCubit({required AuthRepository authRepository, Logger? log})
    : _authRepository = authRepository,
      _log = log ?? Logger(),
      super(AuthenticationState.initial());

  void _checkStatus(AuthenticationStatus authStatus) {
    if (state.status == authStatus) return;
    emit(state.copyWith(status: authStatus));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: AuthenticationStatus.initial));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: AuthenticationStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: AuthenticationStatus.initial));
  }

  void reset() {
    emit(AuthenticationState.initial());
  }

  // void signOut() {
  //   emit(AuthenticationState.initial());
  // }

  Future<void> login() async {
    _checkStatus(AuthenticationStatus.submitting);

    try {
      await _authRepository.loginWithFirebase(
        email: state.email,
        password: state.password,
      );

      emit(state.copyWith(status: AuthenticationStatus.success));
    } catch (err) {
      _log.e('login (firebase) error', error: err);
      String errorMessage =
          err.toString().contains('malformed or has expired')
              ? 'The email and password combination are invalid. Please double check and try again.'
              : err.toString();
      emit(
        state.copyWith(
          errorMessage: errorMessage,
          status: AuthenticationStatus.error,
        ),
      );
    }
  }

  Future<void> register() async {
    _checkStatus(AuthenticationStatus.submitting);

    try {
      await _authRepository.registerUserWithFirebase(
        email: state.email,
        password: state.password,
      );

      emit(state.copyWith(status: AuthenticationStatus.success));
    } catch (err) {
      _log.e('register (firebase) error', error: err);
      String errorMessage =
          err.toString().contains('malformed or has expired')
              ? 'The email and password combination are invalid. Please double check and try again.'
              : err.toString();
      emit(
        state.copyWith(
          errorMessage: errorMessage,
          status: AuthenticationStatus.error,
        ),
      );
    }
  }

  Future<void> resetPassword() async {
    _checkStatus(AuthenticationStatus.resetting);

    try {
      await _authRepository.resetPassword(email: state.email);

      emit(state.copyWith(status: AuthenticationStatus.reset));
    } catch (err) {
      _log.e('reset (firebase) error', error: err);
      String errorMessage =
          err.toString().contains('malformed or has expired')
              ? 'The email and password combination are invalid. Please double check and try again.'
              : err.toString();
      emit(
        state.copyWith(
          errorMessage: errorMessage,
          status: AuthenticationStatus.error,
        ),
      );
    }
  }
}
