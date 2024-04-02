class User {
  late String name;
  late String designation;
  late String department;
  late String tripType;
  late DateTime dateTime;
  late String destination;
  late String car;
  late String starttime;
  bool isExpanded;

  User({
    required this.name,
    required this.designation,
    required this.department,
    required this.tripType,
    required this.dateTime,
    required this.destination,
    required this.car,
    required this.starttime,
    this.isExpanded = false,
  });
}