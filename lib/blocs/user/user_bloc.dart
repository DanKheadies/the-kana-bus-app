import 'dart:typed_data';

import 'package:kana_bus_app/barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  final Logger _log;
  final StorageRepository _storageRepository;
  final UserRepository _userRepository;

  UserBloc({
    required StorageRepository storageRepository,
    required UserRepository userRepository,
    Logger? log,
  }) : _log = log ?? Logger(),
       _storageRepository = storageRepository,
       _userRepository = userRepository,
       super(const UserState()) {
    on<ClearUser>(_onClearUser);
    on<DeleteProfilePhoto>(_onDeleteProfilePhoto);
    on<GetUser>(_onGetUser);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImage>(_onUpdateUserImage);
  }

  void _checkAndEmit(Emitter<UserState> emit, UserStatus status) {
    if (state.userStatus == status) return;
    emit(state.copyWith(userStatus: status));
  }

  void _onClearUser(ClearUser event, Emitter<UserState> emit) {
    emit(state.copyWith(user: User.emptyUser, userStatus: UserStatus.initial));
  }

  void _onDeleteProfilePhoto(
    DeleteProfilePhoto event,
    Emitter<UserState> emit,
  ) async {
    // emit(state.copyWith(userStatus: UserStatus.photoUpload));
    _checkAndEmit(emit, UserStatus.photoUpload);

    try {
      _storageRepository.removeProfileImage(url: state.user.avatarUrl);

      _userRepository.updateUser(
        user: state.user.copyWith(
          avatarUrl: '',
          // updatedAt: DateTime.now()
        ),
      );

      emit(
        state.copyWith(
          user: state.user.copyWith(
            avatarUrl: '',
            // updatedAt: DateTime.now()
          ),
          userStatus: UserStatus.loaded,
        ),
      );
    } catch (err) {
      _log.e('removing user photo error', error: err);
      emit(state.copyWith(userStatus: UserStatus.error));
    }
  }

  void _onGetUser(GetUser event, Emitter<UserState> emit) async {
    _checkAndEmit(emit, UserStatus.loading);

    try {
      User currentUser = await _userRepository.getUser(userId: event.userId);

      emit(
        state.copyWith(
          user: currentUser,
          userStatus:
              currentUser == User.emptyUser
                  ? UserStatus.error
                  : UserStatus.loaded,
        ),
      );
    } catch (err) {
      _log.e('get user error', error: err);
      emit(state.copyWith(user: User.emptyUser, userStatus: UserStatus.error));
    }
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    _checkAndEmit(emit, UserStatus.loading);

    User updatedUser = User.emptyUser;

    // if (event.accountCreation == false) {
    //   updatedUser = event.user.copyWith(updatedAt: DateTime.now());
    // } else {
    //   updatedUser = event.user;
    // }
    updatedUser = event.user;

    try {
      if (event.updateFirebase) {
        await _userRepository.updateUser(user: updatedUser);
      }

      emit(state.copyWith(user: updatedUser, userStatus: UserStatus.loaded));
    } catch (err) {
      _log.e('update user error', error: err);
      emit(state.copyWith(user: updatedUser, userStatus: UserStatus.error));
    }
  }

  void _onUpdateUserImage(
    UpdateUserImage event,
    Emitter<UserState> emit,
  ) async {
    _checkAndEmit(emit, UserStatus.photoUpload);

    if (state.user.avatarUrl != '') {
      _storageRepository.removeProfileImage(url: state.user.avatarUrl);
    }

    String avatarUrl = await _storageRepository.uploadImage(
      bytes: event.bytes,
      imageName: event.imageName,
      user: state.user,
    );

    emit(
      state.copyWith(
        user: state.user.copyWith(
          avatarUrl: avatarUrl,
          // updatedAt: DateTime.now(),
        ),
        userStatus: UserStatus.loaded,
      ),
    );
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    return UserState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    return state.toJson();
  }
}
