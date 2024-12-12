import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A custom [TextFormField] widget that encapsulates a [TextEditingController],
/// label text, validation logic, keyboard type, input formatters, read-only state,
/// and a tap action. It is designed for consistent styling and usability.
///
/// **Variables:**
/// - [controller]: The controller for managing the text input.
/// - [labelText]: The text to display as the label for the input field.
/// - [validator]: The validation function to validate the input.
/// - [keyboardType]: The type of keyboard to display for the input.
/// - [inputFormatters]: The formatters to apply to the input text.
/// - [readOnly]: Indicates whether the input field is read-only (default is false).
/// - [VoidCallback?] onTap: The callback function to execute when the field is tapped.
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? prefixText;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.prefixText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.075,
      child: Stack(
        children: [
          TextFormField(
            controller: controller,
            validator: validator,
            readOnly: readOnly,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: const TextStyle(
              color: Color.fromRGBO(143, 150, 158, 1),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: labelText,
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'default',
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              prefixText: prefixText,
              suffixIcon: readOnly
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        keyboardType == TextInputType.phone
                            ? Icons.phone
                            : Icons.calendar_today_outlined,
                        size: 25,
                      ),
                    )
                  : null,
            ),
            onTap: onTap,
          ),
          if (onTap != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
