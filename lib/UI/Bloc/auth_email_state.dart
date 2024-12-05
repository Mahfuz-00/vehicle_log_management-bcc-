part of 'auth_email_cubit.dart';

/// Abstract class representing the state of the [email] address
/// managed by the [AuthEmailCubit].
/// This class extends [Equatable] to allow for state comparison.
abstract class AuthEmailState extends Equatable {
  const AuthEmailState();

  @override
  List<Object> get props => [];
}

class AuthEmailInitial extends AuthEmailState {}

class AuthEmailSaved extends AuthEmailState {
  final String email;

  const AuthEmailSaved({required this.email});

  @override
  List<Object> get props => [email];
}
