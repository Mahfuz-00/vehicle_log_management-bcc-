import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StartTripAPIService {
  static const String _baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  StartTripAPIService._();

  static Future<StartTripAPIService> create() async {
    var apiService = StartTripAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/* StartTripAPIService() {
    _loadAuthToken();
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<bool> TripStarted({
    required int tripId,
  }) async {
    print('Trip Starting');
    final url = '$_baseUrl/vlm/trip/start/$tripId';
    final Map<String, dynamic> requestBody = {
      'trip_id': tripId,
    };

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        // Add any required headers here
      },
      //body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print(response.body);
      // Request successful
      print('Trip Started successfully');
      return true;
    } else {
      // Request failed
      print('Failed to Start Trip. Status code: ${response.statusCode}');
      return false;
    }
  }
}
