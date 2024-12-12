/// Represents a geographical division with its details.
///
/// This class encapsulates the unique identifier, names, and associated URL
/// of a division.
///
/// **Variables:**
/// - [id]: Unique identifier for the division.
/// - [name]: Name of the division in English.
/// - [bn_name]: Name of the division in Bengali.
/// - [url]: URL associated with the division.
class Routes {
  /// Unique identifier for the division.
  final int id;

  /// Name of the division in English.
  final String name;

  final String? startpoint;

  final String? endpoint;

  /// Name of the division in Bengali.
  final String fare;

  /// URL associated with the division.
  final String url;

/*  final String created_at;
  final String updated_at;*/

  /// Constructor for `Division`.
  ///
  /// - [id]: Unique identifier for the division.
  /// - [name]: Name of the division in English.
  /// - [bn_name]: Name of the division in Bengali.
  /// - [url]: URL associated with the division.
  Routes({
    required this.id,
    required this.name,
    required this.fare,
    required this.url,
    this.startpoint,
    this.endpoint,
    /*required this.created_at, required this.updated_at*/
  });

  /// Factory constructor to create a `Division` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the division.
  /// - Returns: A `Division` instance with `id`, `name`, `bn_name`, and `url`
  ///   populated from the JSON map.
  factory Routes.fromJson(Map<String, dynamic> json) {
    return Routes(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      startpoint: json['start_point'] ?? '',
      endpoint: json['end_point'] ?? '',
      //bn_name: json['bn_name']?? '', // This field is not present in the provided JSON data. Assuming it's a typo and using 'fare' instead.
      fare: json['bn_name'] ?? '',
      url: json['url'] ?? '',
/*      created_at: json['created_at'],
      updated_at: json['updated_at'],*/
    );
  }
}

/// Represents a district with its details.
///
/// This class encapsulates the unique identifier and name of a district.
///
/// **Variables:**
/// - [id]: Unique identifier for the district.
/// - [name]: Name of the district.
class Stoppages {
  /// Unique identifier for the district.
  final int id;

  /// Name of the district.
  final String name;

  final String fare;

  /// Constructor for `District`.
  ///
  /// - [id]: Unique identifier for the district.
  /// - [name]: Name of the district.
  Stoppages({required this.id, required this.name, required this.fare});

  /// Factory constructor to create a `District` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the district.
  /// - Returns: A `District` instance with `id` and `name` populated from the JSON map.
  factory Stoppages.fromJson(Map<String, dynamic> json) {
    return Stoppages(
      id: json['id'],
      name: json['name'],
      fare: json['price'],
    );
  }
}
