import 'package:flutter/material.dart';

class DropdownMenuModel extends StatelessWidget {
  final String label;
  final List<String> options;
  final void Function(String)? onChanged;

  const DropdownMenuModel({
    Key? key,
    required this.label,
    required this.options,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth*0.9,
      height: screenHeight*0.075,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'default',),
          ),
          Spacer(),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => options
                .map((option) => PopupMenuItem(
              child: Text(option, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'default',),),
              value: option,
            ))
                .toList(),
            onSelected: onChanged,
            icon: Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }
}
