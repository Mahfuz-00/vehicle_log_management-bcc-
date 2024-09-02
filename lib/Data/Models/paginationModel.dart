/// Represents the pagination information for a data response.
///
/// This class encapsulates details about the current pagination state,
/// including the URLs for the next and previous pages of data.
///
/// **Variables:**
/// - [nextPage]: A String? that holds the URL for the next page of results, if available.
/// - [previousPage]: A String? that holds the URL for the previous page of results, if available.
///
/// **Actions:**
/// - [canFetchNext]: A boolean getter that determines if there is a next page to fetch.
/// - [canFetchPrevious]: A boolean getter that determines if there is a previous page to fetch.
class Pagination {
  final String? nextPage;
  final String? previousPage;

  Pagination({required this.nextPage, required this.previousPage});

  bool get canFetchNext => nextPage != null && nextPage != "None";
  bool get canFetchPrevious => previousPage != null && previousPage != "None";

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      nextPage: json['next_page'] as String?,
      previousPage: json['previous_page'] as String?,
    );
  }
}
