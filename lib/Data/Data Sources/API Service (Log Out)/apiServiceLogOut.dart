import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class responsible for handling the logout functionality.
///
/// This class provides methods to sign out a user by making an API request
/// to the logout endpoint. It uses the stored authentication token to
/// authenticate the request.
///
/// **Variables:**
/// - [URL]: The base URL of the API endpoint.
/// - [authToken]: The authentication token used for authorization in the API request.
///
/// **Actions:**
/// - [create]: A factory method that initializes the [LogOutApiService] and loads the [authToken].
/// - [_loadAuthToken]: A private method to load the [authToken] from [SharedPreferences].
/// - [signOut]: Sends a GET request to the API to sign out the user. If the request is successful,
class LogOutApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  LogOutApiService._();

  static Future<LogOutApiService> create() async {
    var apiService = LogOutApiService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(authToken);
  }

  Future<bool> signOut() async {
    print(authToken);
    try {
      if (authToken.isEmpty) {
        print(authToken);
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$URL/sign/out'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        print('Sign out successful');
        return true;
      } else {
        print(response.body);
        print('Failed to sign out: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      final response = await http.post(
          Uri.parse('$URL/sign/out'),
          headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
          },
      );
      print(response.body);
      print('Exception during sign out: $e');
      return false;
    }
  }
}
