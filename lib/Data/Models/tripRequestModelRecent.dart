import 'dart:convert';

/// Represents a recent trip request.
///
/// This class contains detailed information about a trip that has recently occurred.
///
/// **Variables:**
/// - [driver]: A String representing the name of the driver.
/// - [Car]: A String representing the name of the car used for the trip.
/// - [id]: An integer representing the unique identifier for the trip.
/// - [name]: A String representing the name of the staff member requesting the trip.
/// - [designation]: A String representing the designation of the staff member.
/// - [department]: A String representing the department of the staff member.
/// - [purpose]: A String representing the purpose of the trip.
/// - [phone]: A String representing the contact phone number of the staff member.
/// - [destinationFrom]: A String representing the starting location of the trip.
/// - [destinationTo]: A String representing the destination of the trip.
/// - [date]: A String representing the date of the trip.
/// - [startTime]: A String representing the scheduled start time of the trip.
/// - [endTime]: A String representing the scheduled end time of the trip.
/// - [distance]: A String representing the approximate distance of the trip.
/// - [category]: A String representing the category of the trip.
/// - [type]: A String representing the type of the trip.
/// - [Duration]: An integer representing the duration of the trip in minutes.
/// - [startTrip]: A DateTime representing the actual start time of the trip, which can be null.
class TripRecent {
  String driver;
  String Car;
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
  int Duration;
  DateTime? startTrip;

  TripRecent({
    required this.driver,
    required this.Car,
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
    required this.Duration,
    this.startTrip,
  });

  factory TripRecent.fromJson(Map<String, dynamic> json) {
    return TripRecent(
      driver: json['driver'],
      Car: json['car'],
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
      Duration: json['duration'],
      startTrip: json['start_trip'] != null ? DateTime.parse(json['start_trip']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver'] = this.driver;
    data['car'] = this.Car;
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
    return data;
  }

  static List<TripRecent> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TripRecent.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<TripRecent> trips) {
    return trips.map((trip) => trip.toJson()).toList();
  }
}
