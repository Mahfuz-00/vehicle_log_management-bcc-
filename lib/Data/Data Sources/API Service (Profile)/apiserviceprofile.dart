import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class that handles fetching the user profile data from the API.
///
/// This class provides methods to retrieve user profile information using an [authToken] for authorization.
///
/// **Variables:**
/// - [URL]: The base URL of the API endpoint.
/// - [authToken]: The authentication token used for authorization in the API request.
///
/// **Actions:**
/// - [fetchUserProfile]: Sends a GET request to the API to fetch the user's profile data.
///   If the request is successful, it returns a [Map<String, dynamic>] containing the user's profile information.
///   If the request fails, it throws an exception and prints relevant error messages.
class ProfileAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';

  late final String authToken;

  Future<Map<String, dynamic>> fetchUserProfile(String authToken) async {
    print('Authen: $authToken');
    try{
        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }

      final response = await http.get(
        Uri.parse('$URL/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
        print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200) {
        print('Profile Loaded successfully.');
        Map<String, dynamic> userProfile = json.decode(response.body);
        print(response.body);
        return userProfile['records'];
      } else {
        print('Failed to load Profile. Status code: ${response.statusCode}');
        throw Exception('Failed to load Profile.');
      }
    } catch(e){
      print('Error sending profile request: $e');
      throw Exception('Error sending profile request');
    }
  }
}
