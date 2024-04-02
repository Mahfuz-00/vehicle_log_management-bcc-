class User {
  late String name;
  late String designation;
  late String department;
  late String tripType;
  late String purpose;
  late DateTime dateTime;
  late String destination;
  late String car;
  late String driver;
  late int driverNumber;
  bool isExpanded;

  User({
    required this.name,
    required this.designation,
    required this.department,
    required this.tripType,
    required this.purpose,
    required this.dateTime,
    required this.destination,
    required this.driver,
    required this.car,
    required this.driverNumber,
    this.isExpanded = false,
  });
}