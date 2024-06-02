import 'dart:convert';

class TripRequestOngoing {
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
  String time;
  String type;
  DateTime? startTrip;
  //DateTime? stopTrip;

  TripRequestOngoing({
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
    required this.time,
    required this.type,
    this.startTrip,
   // this.stopTrip,
  });

  // Method to convert JSON to Trip object
  factory TripRequestOngoing.fromJson(Map<String, dynamic> json) {
    return TripRequestOngoing(
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
      time: json['time'],
      type: json['type'],
      startTrip: json['start_trip'] != null ? DateTime.parse(json['start_trip']) : null,
     // stopTrip: json['stop_trip'] != null ? DateTime.parse(json['stop_trip']) : null,
    );
  }

  // Method to convert Trip object to JSON
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
    data['time'] = this.time;
    data['type'] = this.type;
    if (this.startTrip != null) {
      data['start_trip'] = this.startTrip!.toIso8601String();
    }
   /* if (this.stopTrip != null) {
      data['stop_trip'] = this.stopTrip!.toIso8601String();
    }*/
    return data;
  }

  // Method to convert a list of JSON objects to a list of Trip objects
  static List<TripRequestOngoing> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TripRequestOngoing.fromJson(json)).toList();
  }

  // Method to convert a list of Trip objects to a list of JSON objects
  static List<Map<String, dynamic>> toJsonList(List<TripRequestOngoing> trips) {
    return trips.map((trip) => trip.toJson()).toList();
  }
}
