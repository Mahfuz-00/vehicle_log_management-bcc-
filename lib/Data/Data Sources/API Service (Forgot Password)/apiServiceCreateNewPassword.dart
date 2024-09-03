import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class to handle the creation of a new password.
///
/// This class provides functionality to interact with the API endpoint
/// for creating a new password. The [authToken] is loaded from shared preferences,
/// and the service sends a POST request with the necessary credentials.
///
/// **Variables:**
/// - [url]: The API endpoint for creating a new password.
/// - [authToken]: The authentication token required for the API request.
///
/// **Actions:**
/// - [_loadAuthToken]: Loads the [authToken] from shared preferences.
/// - [create]: Initializes the service and loads the [authToken].
/// - [NewPassword]: Sends a POST request to the API to create a new password with the provided [email], [password], and [confirmPassword].
class CreateNewPasswordAPIService{
  final String url = 'https://bcc.touchandsolve.com/api/forget/password';
  late final String authToken;

  CreateNewPasswordAPIService._();

  static Future<CreateNewPasswordAPIService> create() async {
    var apiService = CreateNewPasswordAPIService._();
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

  Future<String> NewPassword(String email, String password, String confirmPassword) async {
    print(email);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'email': email,
      'new_password': password,
      'password_confirmation': confirmPassword,
    };

    final String requestBodyJson = jsonEncode(requestBody);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('New Password Created successfully.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        print('Failed to create new password. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }

    } catch (e) {
      print('Error creating new password: $e');
      return 'Error creating new password';
    }
  }
}
