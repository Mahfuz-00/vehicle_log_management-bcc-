import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class to handle the forgot password functionality.
///
/// This class provides the necessary methods to interact with the API endpoint
/// for sending an OTP to reset a forgotten password. The [authToken] is loaded
/// from shared preferences, and the service sends a POST request with the user's [email].
///
/// **Variables:**
/// - [url]: The API endpoint for sending the forgot password OTP.
/// - [authToken]: The authentication token required for the API request.
///
/// **Actions:**
/// - [_loadAuthToken]: Loads the [authToken] from shared preferences.
/// - [create]: Initializes the service and loads the [authToken].
/// - [sendForgotPasswordOTP]: Sends a POST request to the API to send an OTP to the provided [email].
class LoginWithEmailAPIService{
  final String url = 'https://bcc.touchandsolve.com/api/send/login/password/otp';
  late final String authToken;

  LoginWithEmailAPIService._();
  LoginWithEmailAPIService();

  static Future<LoginWithEmailAPIService> create() async {
    var apiService = LoginWithEmailAPIService._();
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

  Future<String> sendForgotPasswordOTP(String email) async {
    print(email);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'email': email,
      'app_name' : 'VLM',
    };

    final String requestBodyJson = jsonEncode(requestBody);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('Login OTP sent successfully.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        print('Failed to send Login OTP. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }

    } catch (e) {
      print('Error sending forgot password OTP: $e');
      return 'Error sending forgot password OTP';
    }
  }
}
