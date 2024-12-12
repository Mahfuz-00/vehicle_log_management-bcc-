import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for fetching dashboard items from an API.
///
/// This class manages the authentication token and handles requests to
/// retrieve dashboard data.
///
/// **Variables:**
/// - [baseUrl]: The base URL for the API endpoint.
/// - [authToken]: The authentication token used for API requests.
///
/// **Actions:**
/// - [create]: Creates an instance of [DashboardAPIService] and loads
///   the authentication token from shared preferences.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [fetchDashboardItems]: Sends a GET request to fetch dashboard items
///   and returns the response data as a [Map].
class DashboardAPIService{
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  DashboardAPIService._();

  static Future<DashboardAPIService> create() async {
    var apiService = DashboardAPIService._();
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

  Future<Map<String, dynamic>> fetchDashboardItems() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/vlm/dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        printFieldTypes(jsonData);
        print(jsonData);
        return jsonData;
      } else {
        print(response.statusCode);
        throw Exception('Failed to load dashboard items');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard items: $e');
    }
  }

  void printFieldTypes(dynamic data, [String parentKey = 'root']) {
    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        final fieldKey = '$parentKey > $key';
        print('$fieldKey: ${value.runtimeType}');
        printFieldTypes(value, fieldKey); // Recursively handle nested objects
      });
    } else if (data is List) {
      for (int i = 0; i < data.length; i++) {
        final fieldKey = '$parentKey[$i]';
        print('$fieldKey: ${data[i].runtimeType}');
        printFieldTypes(data[i], fieldKey); // Recursively handle list items
      }
    }
  }



}
