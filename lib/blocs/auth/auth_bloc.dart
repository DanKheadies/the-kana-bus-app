import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kana_bus_app/barrel.dart';
import 'package:logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthenticationCubit _authCubit;
  final AuthRepository _authRepository;
  final Logger _log;
  final UserBloc _userBloc;
  StreamSubscription<auth.User?>? _authUserSubscription;

  AuthBloc({
    required AuthenticationCubit authCubit,
    required AuthRepository authRepository,
    required UserBloc userBloc,
    Logger? log,
  }) : _authCubit = authCubit,
       _authRepository = authRepository,
       _log = log ?? Logger(),
       _userBloc = userBloc,
       super(const AuthState()) {
    on<AuthUserChanged>(_onAuthUserChanged);
    on<DeleteAccount>(_onDeleteAccount);
    on<ResetError>(_onResetError);
    on<ResetPassword>(_onResetPassword);
    on<SignOut>(_onSignOut);

    _setupSubscriptions();
  }

  void _checkAndEmit(Emitter<AuthState> emit, AuthStatus status) {
    if (state.status == status) return;
    emit(state.copyWith(status: status));
  }

  void _clearUserAndReset(Emitter<AuthState> emit) {
    _userBloc.add(ClearUser());

    emit(
      state.initialize().copyWith(
        errorMessage: '',
        status: AuthStatus.unauthenticated,
      ),
    );
  }

  // Set up a Firebase Authentication sub/stream.
  void _setupSubscriptions() {
    _authUserSubscription = _authRepository.user.listen((authUser) async {
      // print('auth sub online');
      if (authUser != null) {
        print('have user: ${authUser.uid}');
        add(AuthUserChanged(authUser: authUser));
        _userBloc.add(GetUser(userId: authUser.uid));
      } else if (authUser == null && state.status == AuthStatus.authenticated) {
        // print('no auth, but have local cache so Sign Out');
        _log.i('no auth, but have local cache so Sign Out');
        add(SignOut());
      }
    });
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        authUser: event.authUser,
        errorMessage: '',
        status: AuthStatus.authenticated,
      ),
    );
  }

  void _onDeleteAccount(DeleteAccount event, Emitter<AuthState> emit) async {
    _checkAndEmit(emit, AuthStatus.submitting);

    try {
      await _authRepository.deleteAccount();
      _clearUserAndReset(emit);
    } catch (err) {
      _log.e('delete account error', error: err);
      emit(
        state.initialize().copyWith(
          errorMessage: err.toString(),
          status: AuthStatus.unknown,
        ),
      );
    }
  }

  void _onResetError(ResetError event, Emitter<AuthState> emit) {
    emit(state.copyWith(errorMessage: ''));
  }

  void _onResetPassword(ResetPassword event, Emitter<AuthState> emit) {
    emit(state.copyWith(errorMessage: ''));
  }

  void _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    _log.i('sign out');
    _checkAndEmit(emit, AuthStatus.submitting);

    try {
      _clearUserAndReset(emit);
      await _authRepository.signOut();
      _authCubit.reset();
    } catch (err) {
      _log.e('sign out error', error: err);
      emit(
        state.initialize().copyWith(
          errorMessage: err.toString(),
          status: AuthStatus.unauthenticated,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    _authUserSubscription = null;
    return super.close();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toJson();
  }
}
