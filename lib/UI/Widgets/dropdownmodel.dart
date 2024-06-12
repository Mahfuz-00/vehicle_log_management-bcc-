import 'package:flutter/material.dart';

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
          underline: Container(), // Remove underline
          isExpanded: true, // Expand dropdown to full width
          hint: Text(widget.label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'default',
            ),), // Use label as hint text
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
