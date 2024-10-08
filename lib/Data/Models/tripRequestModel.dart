import 'dart:convert';

/// Represents a trip request with various details.
///
/// This class holds all the necessary information related to a trip request.
///
/// **Variables:**
/// - [name]: A String representing the name of the person making the request.
/// - [designation]: A String representing the designation of the requester.
/// - [department]: A String indicating the department of the requester.
/// - [purpose]: A String describing the purpose of the trip.
/// - [phone]: A String for the contact phone number of the requester.
/// - [destinationFrom]: A String representing the starting point of the trip.
/// - [destinationTo]: A String representing the destination of the trip.
/// - [date]: A String indicating the date of the trip.
/// - [startTime]: A String representing the starting time of the trip.
/// - [endTime]: A String representing the ending time of the trip.
/// - [distance]: A String indicating the approximate distance of the trip.
/// - [category]: A String categorizing the trip.
/// - [type]: A String specifying the type of the trip.
///
/// **Actions:**
/// - [fromJson]: A factory constructor that creates a TripRequest instance from a JSON map.
/// - [toJson]: A method that converts the TripRequest instance to a JSON map.
/// - [fromJsonList]: A static method that converts a list of JSON maps to a list of TripRequest instances.
/// - [toJsonList]: A static method that converts a list of TripRequest instances to a list of JSON maps.
class TripRequest {
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

  TripRequest({
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
  });

  factory TripRequest.fromJson(Map<String, dynamic> json) {
    return TripRequest(
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
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }

  static List<TripRequest> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TripRequest.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<TripRequest> trips) {
    return trips.map((trip) => trip.toJson()).toList();
  }
}
