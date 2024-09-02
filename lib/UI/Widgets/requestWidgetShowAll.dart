import 'package:flutter/material.dart';
import 'templateerrorcontainer.dart';

/// [RequestsWidgetShowAll] is a StatelessWidget that displays a list of requests with loading and error handling.
///
/// This widget handles loading states and displays a list of request widgets. It is specifically designed
/// to show all available requests based on the provided list. The widget manages different scenarios like
/// loading, error, and displaying requests.
///
/// Parameters:
/// - [loading]: A boolean indicating if the widget is currently in the loading state.
/// - [fetch]: A boolean indicating if data fetching has been initiated and is complete.
/// - [errorText]: A string containing an error message to be displayed when an error occurs.
/// - [listWidget]: A list of widgets representing individual requests.
/// - [fetchData]: A future that fetches the request data.
///
/// Actions:
/// - The widget builds the UI using the [build] method, which constructs a FutureBuilder to handle loading,
///   error, and data display states.
/// - When loading, a circular progress indicator is displayed within a styled container.
/// - If an error occurs during fetching, a method [buildNoRequestsWidget] is called to display the error message.
/// - When fetching is complete and data is available, it checks if the [listWidget] is empty and displays a
///   message accordingly or shows the list of requests.
/// - The widget uses a [ListView.separated] to display the list of requests with a fixed height and padding.
class RequestsWidgetShowAll extends StatelessWidget {
  final bool loading;
  final bool fetch;
  final String errorText;
  final Future<void> fetchData;
  final List<Widget> listWidget;


  const RequestsWidgetShowAll({
    Key? key,
    required this.loading,
    required this.fetch,
    required this.errorText,
    required this.listWidget,
    required this.fetchData,
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
                      itemCount: listWidget.length,
                      itemBuilder: (context, index) {
                        return listWidget[index];
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                    ),
                    SizedBox(height: 10),
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
}
