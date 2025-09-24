part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final auth.User? authUser;

  const AuthUserChanged({this.authUser});

  @override
  List<Object?> get props => [authUser];
}

class DeleteAccount extends AuthEvent {}

class ResetError extends AuthEvent {}

class ResetPassword extends AuthEvent {
  final String email;

  const ResetPassword({required this.email});

  @override
  List<Object?> get props => [email];
}

class SignOut extends AuthEvent {}
