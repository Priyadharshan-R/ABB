import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  String dropdownvalue;
  final List<String> items;
  CustomDropdownButton({
    super.key,
    required this.dropdownvalue,
    required this.items,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      // Initial Value
      value: widget.dropdownvalue,
      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: widget.items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          widget.dropdownvalue = newValue!;
        });
      },
    );
  }
}
