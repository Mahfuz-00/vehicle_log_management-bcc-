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
class TripRequestSubmit {
  dynamic name;
  dynamic designation;
  dynamic department;
  dynamic? purpose;
  dynamic phone;
  dynamic? destinationFrom;
  dynamic? destinationTo;
  dynamic? date;
  dynamic? startTime;
  dynamic? endTime;
  dynamic? distance;
  dynamic category;
  dynamic? type;
  dynamic? route;
  dynamic? stoppage;
  dynamic? startMonth;
  dynamic? endMonth;
  dynamic? fare;
  dynamic? paymentMode;
  dynamic? DateTime;
  dynamic? Driver;
  dynamic? Car;
  dynamic? Duration;
  dynamic? Start;

  TripRequestSubmit({
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
    this.route,
    this.stoppage,
    this.startMonth,
    this.endMonth,
    this.fare,
    this.paymentMode,
    this.Driver,
    this.Car,
    this.Duration,
    this.Start,
    this.DateTime,
  });

  factory TripRequestSubmit.fromJson(Map<String, dynamic> json) {
    return TripRequestSubmit(
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
      fare: json['fare'],
      paymentMode: json['payment_mode'],
      Driver: json['driver'],
      Car: json['car'],
      Duration: json['duration'],
      Start: json['start'],
      DateTime: json['date_time'],
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
    data['route_id'] = this.route;
    data['stoppage_id'] = this.stoppage;
    data['start_month_and_year'] = this.startMonth;
    data['end_month_and_year'] = this.endMonth;
    data['fare'] = this.fare;
    data['payment_mode'] = this.paymentMode;
    data['driver'] = this.Driver;
    data['car'] = this.Car;
    data['duration'] = this.Duration;
    data['start'] = this.Start;
    data['date_time'] = this.DateTime;
    return data;
  }

  static List<TripRequestSubmit> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TripRequestSubmit.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<TripRequestSubmit> trips) {
    return trips.map((trip) => trip.toJson()).toList();
  }
}
