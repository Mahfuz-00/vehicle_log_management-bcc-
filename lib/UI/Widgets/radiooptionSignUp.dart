import 'package:flutter/material.dart';

/// [RadioListTileGroup] is a StatefulWidget that provides a group of radio list tiles for user selection.
///
/// It allows users to select one option from a provided list of options. The selected option can be managed
/// through the widget's state and can also notify external listeners via a callback function.
///
/// Parameters:
/// - [options]: A required list of [String] options displayed as radio tiles.
/// - [selectedOption]: An optional initial value of type [String] for the selected option.
/// - [onChanged]: An optional callback function that takes a [String] parameter to handle selection changes.
///
/// Internal State:
/// - [_selectedOption]: A local variable that stores the currently selected option. It is initialized to
///   [widget.selectedOption] if provided; otherwise, it defaults to the first option in [widget.options].
///
/// Actions:
/// - The radio tile's [onChanged] callback updates [_selectedOption] when a new option is selected,
///   and invokes the [widget.onChanged] function if it is not null.
class RadioListTileGroup extends StatefulWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String)? onChanged;

  const RadioListTileGroup({
    Key? key,
    required this.options,
    this.selectedOption,
    this.onChanged,
  }) : super(key: key);

  @override
  _RadioListTileGroupState createState() => _RadioListTileGroupState();
}

class _RadioListTileGroupState extends State<RadioListTileGroup> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption ?? widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          horizontalTitleGap: 2,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Wrap(
        children: widget.options.map((option) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.45,
            child: RadioListTile<String>(
              title: Text(
                option,
                style: TextStyle(
                  fontFamily: 'default',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color:
                  _selectedOption == option ? Colors.deepPurple : Colors.green,
                ),
              ),
              value: option,
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value!;
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                });
              },
              activeColor:
                  _selectedOption == option ? Colors.deepPurple : Colors.green,
              contentPadding: EdgeInsets.symmetric(horizontal: 2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
