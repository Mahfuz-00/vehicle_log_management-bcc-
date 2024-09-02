import 'package:flutter/material.dart';

/// [DropdownMenuModel] is a stateful widget that represents a customizable dropdown menu.
///
/// This widget allows users to select an option from a dropdown list, with an option to handle
/// the selection and return the associated car ID. It can display a label for the dropdown and
/// trigger callback functions when the selected option or car ID changes.
///
/// [label] is the text displayed above the dropdown to indicate the selection purpose.
/// [options] is a list of strings representing the options available in the dropdown.
/// [selectedOption] is an optional parameter representing the currently selected option.
/// [onChanged] is a callback function that is triggered when the selected option changes.
/// [onCarIdChanged] is a callback function that is triggered when the car ID associated with
/// the selected option changes.
///
/// The constructor requires [label] and [options] to be passed as arguments, while other parameters
/// are optional.
class DropdownMenuModel extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? selectedOption;
  final void Function(String?)? onChanged;
  final void Function(String?)? onCarIdChanged;

  const DropdownMenuModel({
    Key? key,
    required this.label,
    required this.options,
    this.selectedOption,
    this.onChanged,
    this.onCarIdChanged,
  }) : super(key: key);

  @override
  _DropdownMenuModelState createState() => _DropdownMenuModelState();
}

class _DropdownMenuModelState extends State<DropdownMenuModel> {
  String? _selectedOption;
  String? _selectedCarId;

  String? _getCarIdFromOption(String? option) {
    if (option == null) {
      return null;
    }
    final parts = option.split('-');
    return parts.length == 3 ? parts[2].trim() : null;
  }

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
    _selectedCarId = _getCarIdFromOption(widget.selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.075,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        alignment: Alignment.center,
        child: DropdownButton<String>(
          underline: Container(),
          isExpanded: true,
          hint: Text(widget.label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'default',
            ),),
          value: _selectedOption,
          onChanged: (newValue) {
            setState(() {
              _selectedOption = newValue;
              widget.onChanged?.call(newValue);
              _selectedCarId = _getCarIdFromOption(newValue);
              widget.onCarIdChanged?.call(_selectedCarId);
            });
          },
          items: widget.options.map((String option) {
            final name = option.split('-').getRange(0, 2).join('-').trim();
            return DropdownMenuItem<String>(
              value: option,
              child: Text(name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),),
            );
          }).toList(),
        ),
      ),
    );
  }
}
