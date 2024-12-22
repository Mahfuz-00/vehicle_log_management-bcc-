import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for fetching available drivers from an API.
///
/// This class manages the authentication token and handles requests to
/// retrieve available driver data.
///
/// **Variables:**
/// - [baseUrl]: The base URL for the API endpoint.
/// - [authToken]: The authentication token used for API requests.
///
/// **Actions:**
/// - [create]: Creates an instance of [FetchPickDropDriverAPIService] and loads
///   the authentication token from shared preferences.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [fetchDrivers]: Sends a GET request to the API endpoint to fetch
///   available drivers and returns the response data as a [Map].
class FetchPickDropDriverAPIService{
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  FetchPickDropDriverAPIService._();

  static Future<FetchPickDropDriverAPIService> create() async {
    var apiService = FetchPickDropDriverAPIService._();
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

  Future<Map<String, dynamic>> fetchDrivers(dynamic id) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      print(id);
      final response = await http.get(
        Uri.parse('$baseUrl/vlm/pick/drop/driver/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load Drivers');
      }
    } catch (e) {
      throw Exception('Error fetching Drivers: $e');
    }
  }
}
