import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for assigning a car to a trip via an API.
///
/// This class handles the assignment of cars to trips and manages the
/// authentication token required for API requests.
///
/// **Variables:**
/// - [authToken]: The authentication token used for API requests.
/// - [_baseUrl]: The base URL for the API endpoint.
///
/// **Actions:**
/// - [create]: Creates an instance of [AssignCarAPIService] and loads the
///   authentication token from shared preferences.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [assignCarToTrip]: Sends a POST request to assign a car to a trip using
///   the provided [tripId] and [carId].
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
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Car assigned successfully');
      return true;
    } else {
      print('Failed to assign car. Status code: ${response.statusCode}');
      return false;
    }
  }
}
