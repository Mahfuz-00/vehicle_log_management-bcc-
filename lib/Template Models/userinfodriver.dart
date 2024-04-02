class User {
  late String name;
  late String designation;
  late String department;
  late String tripType;
  late DateTime dateTime;
  late String destination;
  late String duration;
  bool isExpanded;

  User({
    required this.name,
    required this.designation,
    required this.department,
    required this.tripType,
    required this.dateTime,
    required this.destination,
    required this.duration,
    this.isExpanded = false,
  });
}