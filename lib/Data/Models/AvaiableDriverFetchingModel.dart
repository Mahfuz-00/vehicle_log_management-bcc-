/// Represents the information card for a driver in the admin panel.
///
/// This class contains details about a driver and their associated car.
///
/// **Variables:**
/// - [Name]: A String representing the name of the driver.
/// - [CarName]: A String representing the name of the car associated with the driver.
class DriverInfoCardAdmin {
  final String? Name;
  final String? CarName;

  const DriverInfoCardAdmin({
    required this.Name,
    required this.CarName,
  });
}
