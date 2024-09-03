import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for updating the user's profile picture via an API request.
///
/// This class provides methods to handle the uploading of a profile picture using a [File] object and an [authToken]
/// for authorization. It communicates with the backend to update the user's profile picture.
///
/// **Variables:**
/// - [URL]: The API endpoint for updating the profile picture.
/// - [authToken]: The authentication token used for authorizing the API request.
///
/// **Actions:**
/// - [create]: A factory method that initializes the [APIProfilePictureUpdate] class and loads the [authToken].
/// - [_loadAuthToken]: Loads the [authToken] from shared preferences.
/// - [updateProfilePicture]: Sends a POST request to the API with the selected image file. It constructs a multipart
///   request containing the image file, and if the request is successful, it returns a [ProfilePictureUpdateResponse].
///   If the request fails, it throws an exception and prints relevant error messages.
class PasswordUpdateAPIService {
  String baseURL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  PasswordUpdateAPIService._();

  static Future<PasswordUpdateAPIService> create() async {
    var apiService = PasswordUpdateAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    final String token = await authToken;
    print('Authen:: $authToken');
    try {
      if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      print('Current $currentPassword');
      print('New $newPassword');
      print('Confirm $passwordConfirmation');

      final requestBody = jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'password_confirmation': passwordConfirmation,
      });

      print('Request Body: $requestBody'); 
      print('Auth: $authToken');

      final response = await http.post(
        Uri.parse('$baseURL/update/password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('password');
        final responseData = jsonDecode(response.body);
        print(response.body);
        final responseMessage = responseData['message'];
        print(responseMessage);
        return responseMessage;
      } else {
        print(response.statusCode);
        print(response.body);
        final responseData = jsonDecode(response.body);
        final responseError = responseData['errors'];
        print(responseError);
        final List<dynamic> responseMessageList = responseError['current_password'];
        final String responseMessage = responseMessageList.join(', ');
        print(responseMessage);
        print(response.request);
        return responseMessage.toString();
      }
    } catch (e) {
      throw Exception('Failed to update Password: $e');
    }
  }
}
