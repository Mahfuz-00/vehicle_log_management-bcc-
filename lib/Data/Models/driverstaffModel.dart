class DriveTripRoute {
  final dynamic routeId;
  final dynamic name;
  final dynamic startTime;
  final dynamic endTime;
  final dynamic date;
  final Map<String, dynamic> stoppages;

  // Constructor
  DriveTripRoute({
    required this.routeId,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.stoppages,
  });

  // Factory constructor to create an instance from JSON (useful for API responses)
  factory DriveTripRoute.fromJson(Map<String, dynamic> json) {
    return DriveTripRoute(
      routeId: json['route_id'],
      name: json['name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      date: json['date'],
      stoppages: Map<String, String>.from(json['stoppages']),
    );
  }

  // Method to convert an instance to JSON (useful for sending data to an API)
  Map<String, dynamic> toJson() {
    return {
      'route_id': routeId,
      'name': name,
      'start_time': startTime,
      'end_time': endTime,
      'date': date,
      'stoppages': stoppages,
    };
  }
}
