import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/userInfoUpdateModel.dart';

/// A service class for updating user profile information via an API request.
///
/// This class handles the process of sending updated user information to the backend, such as the user's name, phone,
/// and userId, along with the [authToken] for authorization.
///
/// **Variables:**
/// - [authToken]: The authentication token used to authorize the API request.
/// - [URL]: The API endpoint for updating the user profile.
///
/// **Actions:**
/// - [create]: A factory method that initializes the [UpdateUserAPIService] class and loads the [authToken].
/// - [_loadAuthToken]: Loads the [authToken] from shared preferences.
/// - [updateUserProfile]: Sends a POST request to the API with updated user data ([userId], [name], [phone]).
class UpdateUserAPIService {
  late final String authToken;
  String URL = "https://bcc.touchandsolve.com/api/user/profile/update";

  UpdateUserAPIService._();

  static Future<UpdateUserAPIService> create() async {
    var apiService = UpdateUserAPIService._();
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

  Future<String> updateUserProfile(UserProfileUpdateModel userData) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      var response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          'Authorization': 'Bearer $token'
        },
        body: {
          'userId': userData.userId,
          'name': userData.name,
          'phone': userData.phone,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('User profile updated successfully!');
        return jsonResponse['message'];
      } else {
        print('Failed to update user profile: ${response.body}');
        return 'Failed to update user profile. Please try again.';
      }
    } catch (e) {
      var response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          'Authorization': 'Bearer $token'
        },
        body: {
          'userId': userData.userId,
          'name': userData.name,
          'phone': userData.phone,
        },
      );
      print(response.body);
      print('Error occurred while updating user profile: $e');
      return 'Failed to update user profile. Please try again.';
    }
  }
}
