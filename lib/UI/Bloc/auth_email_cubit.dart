import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_email_state.dart';

/// A Cubit class for managing [email] state.
///
/// This Cubit is responsible for handling the [email] state within the application.
/// It allows for saving and clearing the [email], emitting the appropriate states
/// to notify listeners of changes.
class AuthEmailCubit extends Cubit<AuthEmailState> {
  AuthEmailCubit() : super(AuthEmailInitial());

  void saveAuthEmail(String email) {
    emit(AuthEmailSaved(email: email));
    print('Email saved in Cubit: $email');
  }

  void clearAuthEmail() {
    emit(AuthEmailInitial());
    print('Email cleared from Cubit');
  }
}

