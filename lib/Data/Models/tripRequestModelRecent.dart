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
class RecentTrip {
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

  RecentTrip({
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

  factory RecentTrip.fromJson(Map<String, dynamic> json) {
    return RecentTrip(
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
      route: json['route'],
      stoppage: json['stoppage'],
      startMonth: json['start_month_year'],
      endMonth: json['end_month_year'],
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
    data['route'] = this.route;
    data['stoppage'] = this.stoppage;
    data['start_month_year'] = this.startMonth;
    data['end_month_year'] = this.endMonth;
    data['fare'] = this.fare;
    data['payment_mode'] = this.paymentMode;
    data['driver'] = this.Driver;
    data['car'] = this.Car;
    data['duration'] = this.Duration;
    data['start'] = this.Start;
    data['date_time'] = this.DateTime;
    return data;
  }

  static List<RecentTrip> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RecentTrip.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<RecentTrip> trips) {
    return trips.map((trip) => trip.toJson()).toList();
  }
}
