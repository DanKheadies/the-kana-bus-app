part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class ClearUser extends UserEvent {}

class DeleteProfilePhoto extends UserEvent {}

class GetUser extends UserEvent {
  final String userId;

  const GetUser({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUser extends UserEvent {
  final bool? accountCreation;
  final bool updateFirebase;
  final User user;

  const UpdateUser({
    required this.updateFirebase,
    required this.user,
    this.accountCreation = false,
  });

  @override
  List<Object?> get props => [accountCreation, updateFirebase, user];
}

class UpdateUserImage extends UserEvent {
  final Uint8List bytes;
  final String imageName;

  const UpdateUserImage({required this.bytes, required this.imageName});

  @override
  List<Object?> get props => [bytes, imageName];
}
