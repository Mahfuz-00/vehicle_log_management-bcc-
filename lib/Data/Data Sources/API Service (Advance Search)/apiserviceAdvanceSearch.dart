import 'dart:convert';  // For encoding/decoding JSON
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdvanceSearchAPIService {
  // Define the base URL for the API
  final String _baseUrl = 'https://bcc.touchandsolve.com/api/vlm/trip/search';
  late final String authToken;

  AdvanceSearchAPIService._();

  static Future<AdvanceSearchAPIService> create() async {
    var apiService = AdvanceSearchAPIService._();
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

  // Function to fetch search results from the API
  Future<List<Map<String, dynamic>>> searchAPI({
    required String? name,
    required String? vehicleName,
    required String? driverName,
    required String? locationName,
    required String? locationDate,
    required String? locationType,
    required String? stoppageName,
    required String? date,
  }) async {
   // _loadAuthToken();
    // Define the parameters to send in the request
    final Map<String, String> params = {
      'name': name?? '',
      'vehicle_name': vehicleName ?? '',
      'driver_name': driverName ?? '',
      'location_name': locationName ?? '',
      'location_date': locationDate ?? '',
      'location_type': locationType ?? '',
      'stoppage_name': stoppageName ?? '',
      'date': date ?? '',
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken', // Make sure to replace with your token
        },
        body: json.encode(params), // Pass parameters as JSON
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Assuming the 'records' key contains the 'Trips' list
        if (jsonResponse['records'] != null && jsonResponse['records']['Trips'] is List) {
          final List<dynamic> dataList = jsonResponse['records']['Trips'];

          // Return the list of maps
          return dataList.map((e) => e as Map<String, dynamic>).toList();
        } else {
          throw Exception('Trips data not found in the response');
        }
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
