import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../Data/Models/profileModelFull.dart';

part 'auth_state.dart';

/// A Cubit class responsible for managing user authentication state.
///
/// The `AuthCubit` handles user authentication actions such as login, logout,
/// and fetching or updating the user profile. It emits different states
/// based on the user's actions.
///
/// ### States:
/// - [AuthInitial]: The initial state when no user is authenticated.
/// - [AuthAuthenticated]: The state when a user is authenticated with a valid profile and token.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login(UserProfile userProfile, String token) {
    emit(AuthAuthenticated(userProfile: userProfile, token: token));
    print('User profile and token saved in Cubit:');
    print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.photo}');
    print('Token: $token');
  }

  void updateProfile(UserProfile userProfile) {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      emit(AuthAuthenticated(
        userProfile: userProfile,
        token: currentState.token,
      ));
      print('User profile updated in Cubit:');
      print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.photo}');
    }
  }

  void logout() {
    emit(AuthInitial());
    print('User profile and token removed from Cubit');
  }
}
