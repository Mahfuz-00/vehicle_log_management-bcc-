import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordCustomTextFormField extends StatelessWidget {
  final TextEditingController textController;
  final FocusNode currentFocusNode;
  final FocusNode? nextFocusNode;

  const ForgotPasswordCustomTextFormField({
    Key? key,
    required this.textController,
    required this.currentFocusNode,
    this.nextFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: 65,
      alignment: Alignment.center,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: textController,
        focusNode: currentFocusNode,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Allow only digits
          LengthLimitingTextInputFormatter(1),
        ],
        style: const TextStyle(
          color: Color.fromRGBO(143, 150, 158, 1),
          fontSize: 35,
          fontWeight: FontWeight.bold,
          fontFamily: 'default',
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(25, 192, 122, 1),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(25, 192, 122, 1),
              width: 2.0,
            ),
          ),
          labelText: '',
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            nextFocusNode!.requestFocus();
          }
        },
      ),
    );
  }
}