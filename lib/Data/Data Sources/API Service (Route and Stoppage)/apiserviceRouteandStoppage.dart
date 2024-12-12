import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vehicle_log_management/Data/Models/route.dart';

/// A service class for managing region-related API requests.
///
/// This class is responsible for fetching data related to divisions,
/// districts, upazilas, unions, and NTTN providers from the API.
///
/// **Actions:**
/// - [fetchDivisions]: Sends a GET request to retrieve a list of
///   divisions and returns it as a list of [Division] objects.
/// - [fetchDistricts]: Sends a GET request to retrieve a list of
///   districts for a specific [divisionId] and returns it as a list of
///   [District] objects.
/// - [fetchUpazilas]: Sends a GET request to retrieve a list of
///   upazilas for a specific [districtId] and returns it as a list of
///   [Upazila] objects.
/// - [fetchUnions]: Sends a GET request to retrieve a list of
///   unions for a specific [upazilaId] and returns it as a list of
///   [Union] objects.
/// - [fetchNTTNProviders]: Sends a GET request to retrieve a list of
///   NTTN providers for a specific [unionId] and returns it as a list of
///   [NTTNProvider] objects.
///
/// **Variables:**
/// - [URL]: The base URL for the API.
/// - [authToken]: The authentication token used for API requests.
class RouteAndStoppageAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  RouteAndStoppageAPIService.create(this.authToken);

  Future<List<Routes>> fetchRoutes() async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(
        Uri.parse('$URL/vlm/route'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'] ?? [];
          print(records);
          final List<Routes> routes =
          records.map((record) => Routes.fromJson(record)).toList();
          print(routes);
          return routes;
        } else {
          throw Exception(
              'Invalid API response: missing routes data :: ${response.body}');
        }
      } else {
        print('Failed to load all routes: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      if (e is FormatException) {
        final response = await http.get(Uri.parse('$URL/vlm/route'));
        print('Failed to decode JSON: ${response.body}');
        print('Failed to decode JSON: ${response.statusCode}');
      } else {
        final response = await http.get(Uri.parse('$URL/vlm/route'));
        print('Failed to load a Routes: $e, ${response.statusCode}');
      }
      return [];
    }
  }

  Future<List<Stoppages>> fetchStoppages(String routeId) async {
    print(routeId);
    try {
      print('API Token :: $authToken');
      final response = await http.get(Uri.parse('$URL/vlm/stoppage/$routeId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<Stoppages> stoppages =
          records.map((record) => Stoppages.fromJson(record)).toList();
          print(stoppages);
          return stoppages;
        } else {
          throw Exception(
              'Invalid API response: missing stoppages data :: ${response.body}');
        }
      } else {
        throw Exception('Failed to load stoppages');
      }
    } catch (e) {
      if (e is FormatException) {
        final response = await http.get(Uri.parse('$URL/vlm/stoppage/$routeId'));
        print('Failed to decode JSON: ${response.body}');
      } else {
        final response = await http.get(Uri.parse('$URL/vlm/stoppage/$routeId'));
        print('Failed to load a stoppages: $e, ${response.statusCode}');
      }
      return [];
    }
  }
}
