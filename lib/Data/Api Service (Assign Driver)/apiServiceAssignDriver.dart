import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AssignCarAPIService {
  static const String _baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  AssignCarAPIService._();

  static Future<AssignCarAPIService> create() async {
    var apiService = AssignCarAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/* AssignCarAPIService() {
    _loadAuthToken();
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

 Future<bool> assignCarToTrip({
    required int tripId,
    required int carId,
  }) async {
    print('Assigning car to trip');
    final url = '$_baseUrl/vlm/trip/assign/car';
    final Map<String, dynamic> requestBody = {
      'trip_id': tripId,
      'car_id': carId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        // Add any required headers here
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Request successful
      print('Car assigned successfully');
      return true;
    } else {
      // Request failed
      print('Failed to assign car. Status code: ${response.statusCode}');
      return false;
    }
  }
}
