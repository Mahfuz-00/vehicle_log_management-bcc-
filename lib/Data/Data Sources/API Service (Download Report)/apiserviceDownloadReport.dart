import 'dart:convert'; // For encoding/decoding JSON
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportDownloadAPIService {
  // Define the base URL for the API
  final String _baseUrl = 'https://bcc.touchandsolve.com/api/vlm/trip/search';
  late final String authToken;

  ReportDownloadAPIService._();

  static Future<ReportDownloadAPIService> create() async {
    var apiService = ReportDownloadAPIService._();
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
  Future<Map<String, dynamic>?> DownloadReport({
    required String printType,
    required String? name,
    required String? vehicleName,
    required String? driverName,
    required String? locationName,
    required String? locationDate,
    required String? locationType,
    required String? stoppageName,
    required String? stoppagedate,
    required String? routeType,
  }) async {
    print('Print type: $printType');
    print('Name: $name');
    print('Vehicle Name: $vehicleName');
    print('Driver Name: $driverName');
    print('Location Name: $locationName');
    print('Location Date: $locationDate');
    print('Location Type: $locationType');
    print('Stoppage Name: $stoppageName');
    print('Stoppage Date: $stoppagedate');
    print('Route Type: $routeType');

    String url = '';
    if (printType == 'PDF') {
      url = 'https://bcc.touchandsolve.com/api/vlm/pdf/download/trips';
    } else if (printType == 'Excel') {
      url = 'https://bcc.touchandsolve.com/api/vlm/excel/download/trips';
    }
    // _loadAuthToken();
    // Define the parameters to send in the request
    final Map<String, String> params = {
      'name': name ?? '',
      'vehicle_name': vehicleName ?? '',
      'driver_name': driverName ?? '',
      'location_name': locationName ?? '',
      'location_date': locationDate ?? '',
      'location_type': locationType ?? '',
      'stoppage_name': stoppageName ?? '',
      'stoppage_date': stoppagedate ?? '',
      'route_type': routeType ?? '',
    };

    print(params);

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
          // Make sure to replace with your token
        },
        body: /*json.encode(params)*/ {
          'name': name ?? '',
          'vehicle_name': vehicleName ?? '',
          'driver_name': driverName ?? '',
          'location_name': locationName ?? '',
          'location_date': locationDate ?? '',
          'location_type': locationType ?? '',
          'stoppage_name': stoppageName ?? '',
          'stoppage_date': stoppagedate ?? '',
          'route_type': routeType ?? '',
        }, // Pass parameters as JSON
      );

      print('Response Code: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return jsonResponse;

        /*// Assuming the 'records' key contains the 'Trips' list
        if (jsonResponse['records'] != null && jsonResponse['records']['Trips'] is List) {
          final List<dynamic> dataList = jsonResponse['records']['Trips'];

          // Return the list of maps
          return dataList.map((e) => e as Map<String, dynamic>).toList();
        } else {
          throw Exception('Trips data not found in the response');
        }*/
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
