import 'dart:convert';

/// Represents a trip request for an SR Officer.
///
/// This class contains detailed information about a trip requested by an SR Officer.
///
/// **Variables:**
/// - [id]: An integer representing the unique identifier for the trip.
/// - [name]: A String representing the name of the SR Officer requesting the trip.
/// - [designation]: A String representing the designation of the SR Officer.
/// - [department]: A String representing the department of the SR Officer.
/// - [purpose]: A String representing the purpose of the trip.
/// - [phone]: A String representing the contact phone number of the SR Officer.
/// - [destinationFrom]: A String representing the starting location of the trip.
/// - [destinationTo]: A String representing the destination of the trip.
/// - [date]: A String representing the date of the trip.
/// - [startTime]: A String representing the scheduled start time of the trip.
/// - [endTime]: A String representing the scheduled end time of the trip.
/// - [distance]: A String representing the approximate distance of the trip.
/// - [category]: A String representing the category of the trip.
/// - [type]: A String representing the type of the trip.
class SROfficerTripRequest {
  int id;
  String name;
  String designation;
  String department;
  String purpose;
  String phone;
  String destinationFrom;
  String destinationTo;
  String date;
  String startTime;
  String endTime;
  String distance;
  String category;
  String type;
  String route;
  String stoppage;
  String startMonth;
  String endMonth;

  SROfficerTripRequest({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.purpose,
    required this.phone,
    required this.destinationFrom,
    required this.destinationTo,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.category,
    required this.type,
    required this.route,
    required this.stoppage,
    required this.startMonth,
    required this.endMonth,
  });

  factory SROfficerTripRequest.fromJson(Map<String, dynamic> json) {
    return SROfficerTripRequest(
      id: json['trip_id'],
      name: json['name'],
      designation: json['designation'],
      department: json['department'],
      purpose: json['purpose'],
      phone: json['phone'],
      destinationFrom: json['destination_from'],
      destinationTo: json['destination_to'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      distance: json['approx_distance'],
      category: json['trip_category'],
      type: json['type'],
      route: json['route_name'],
      stoppage: json['stoppage_name'],
      startMonth: json['start_month_and_year'],
      endMonth: json['end_month_and_year'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['purpose'] = this.purpose;
    data['phone'] = this.phone;
    data['destination_from'] = this.destinationFrom;
    data['destination_to'] = this.destinationTo;
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['approx_distance'] = this.distance;
    data['trip_category'] = this.category;
    data['type'] = this.type;
    data['route_name'] = this.route;
    data['stoppage_name'] = this.stoppage;
    data['start_month_and_year'] = this.startMonth;
    data['end_month_and_year'] = this.endMonth;
    return data;
  }

  static List<SROfficerTripRequest> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SROfficerTripRequest.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<SROfficerTripRequest> trips) {
    return trips.map((trip) => trip.toJson()).toList();
  }
}
