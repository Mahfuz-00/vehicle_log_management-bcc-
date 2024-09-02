import 'package:flutter/material.dart';
import 'package:vehicle_log_management/UI/Widgets/templateerrorcontainer.dart';
import '../../Data/Models/paginationModel.dart';

/// [RequestsWidget] is a StatelessWidget that displays a list of requests with various loading states.
///
/// This widget handles different scenarios: loading, error, and displaying a list of requests. It takes in parameters
/// that dictate its behavior and appearance. The widget can display a loading indicator, an error message, or a list of
/// request widgets with an optional "See All" button for pagination.
///
/// Parameters:
/// - [loading]: A boolean indicating if the widget is currently loading data.
/// - [fetch]: A boolean indicating if data fetching has been initiated.
/// - [errorText]: A string containing an error message to be displayed when an error occurs.
/// - [listWidget]: A list of widgets representing individual requests.
/// - [fetchData]: A future that fetches the request data.
/// - [numberOfWidgets]: An integer that limits the number of widgets displayed.
/// - [showSeeAllButton]: A boolean indicating whether the "See All" button should be shown.
/// - [seeAllButtonText]: A string containing the text for the "See All" button.
/// - [nextView]: An optional widget to navigate to when the "See All" button is pressed.
/// - [pagination]: A boolean indicating if pagination is enabled.
///
/// Actions:
/// - The widget builds the UI using the [build] method, which constructs a FutureBuilder to handle loading,
///   error, and data display states.
/// - When loading, a circular progress indicator is displayed.
/// - If there is an error, a method [buildNoRequestsWidget] is called to display the error message.
/// - If the data is successfully fetched, the widget displays a list of requests up to the specified limit
///   [numberOfWidgets].
/// - If the list is empty, the same method for displaying no requests is called.
/// - The [buildSeeAllButton] method constructs a button to navigate to the next view if pagination is enabled.
class RequestsWidget extends StatelessWidget {
  final bool loading;
  final bool fetch;
  final String errorText;
  final Future<void> fetchData;
  final List<Widget> listWidget;
  final int numberOfWidgets;
  final bool showSeeAllButton;
  final String seeAllButtonText;
  final Widget? nextView;
  final bool pagination;

  const RequestsWidget({
    Key? key,
    required this.loading,
    required this.fetch,
    required this.errorText,
    required this.listWidget,
    required this.fetchData,
    required this.numberOfWidgets,
    required this.showSeeAllButton,
    required this.seeAllButtonText,
    required this.nextView,
    required this.pagination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: FutureBuilder<void>(
        future: loading ? null : fetchData,
        builder: (context, snapshot) {
          if (!fetch) {
            return Container(
              height: 200,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // Handle errors
            return buildNoRequestsWidget(screenWidth, 'Error: $errorText');
          } else if (fetch) {
            if (listWidget.isEmpty) {
              return buildNoRequestsWidget(screenWidth, errorText);
            } else if (listWidget.isNotEmpty) {
              return Container(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listWidget.length > numberOfWidgets ? numberOfWidgets : listWidget.length,
                      itemBuilder: (context, index) {
                        return listWidget[index];
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                    ),
                    SizedBox(height: 10),
                    if (pagination)
                      buildSeeAllButton(context),
                  ],
                ),
              );
            }
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget buildSeeAllButton(BuildContext context) {
    return Center(
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.7,
              MediaQuery.of(context).size.height * 0.08,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => nextView!));
          },
          child: Text(
            seeAllButtonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
            ),
          ),
        ),
      ),
    );
  }
}
