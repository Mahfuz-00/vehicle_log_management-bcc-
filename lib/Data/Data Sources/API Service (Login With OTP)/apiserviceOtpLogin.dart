import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class to handle OTP verification functionality.
///
/// This class provides the necessary methods to interact with the API endpoint
/// for verifying OTP sent to the user's [email]. The [authToken] is loaded
/// from shared preferences, and the service sends a POST request with the user's [email] and [OTP].
///
/// **Variables:**
/// - [url]: The API endpoint for OTP verification.
/// - [authToken]: The authentication token required for the API request.
///
/// **Actions:**
/// - [_loadAuthToken]: Loads the [authToken] from shared preferences.
/// - [create]: Initializes the service and loads the [authToken].
/// - [OTPVerification]: Sends a POST request to the API to verify the [OTP] for the provided [email].
class OTPLoginAPIService{
  final String url = 'https://bcc.touchandsolve.com/api/vlm/login';
  late final String authToken;

  OTPLoginAPIService._();

  static Future<OTPLoginAPIService> create() async {
    var apiService = OTPLoginAPIService._();
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

  Future<String> OTPVerification(String email, String OTP) async {
    print(email);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'email': email,
      'otp': OTP,
    };

    final String requestBodyJson = jsonEncode(requestBody);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('OTP Invoked.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        // Extract the required fields.
        var message = jsonResponse['message'];
        var userType = jsonResponse['userType'];
        var token = jsonResponse['token'];

        // Combine the fields into a single string.
        return 'Message: $message, User Type: $userType, Token: $token';
      } else {
        print('Failed to send OTP. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }

    } catch (e) {
      print('Error sending OTP: $e');
      return 'Error sending OTP';
    }
  }
}
