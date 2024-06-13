import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/tripRequestModel.dart';


class APIServiceTripRequest {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final Future<String> authToken;

  APIServiceTripRequest._();

  static Future<APIServiceTripRequest> create() async {
    var apiService = APIServiceTripRequest._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  APIServiceTripRequest() {
    authToken = _loadAuthToken(); // Assigning the future here
    print('triggered');
  }

  Future<String> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Load Token');
    print(token);
    return token;
  }

  Future<String> postTripRequest(TripRequest request) async {
    final String token = await authToken; // Wait for the authToken to complete
    try {
      if (token.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      final http.Response response = await http.post(
        Uri.parse('$URL/vlm/trip/request'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Use token here
        },
        body: jsonEncode(request.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Trip request sent successfully.');
        return jsonResponse['message'];
      } else {
        print('Failed to send Trip request. Status code: ${response.statusCode}');
        return 'Failed to send Trip request';
      }
    } catch (e) {
      print('Error sending Trip request: $e');
      return 'Error sending Trip request';
    }
  }
}
