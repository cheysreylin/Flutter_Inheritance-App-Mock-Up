import 'package:flutter/material.dart';

class RelativeDropdownItems extends StatelessWidget {
  final String dropdownValue;
  final List<String> items;
  final Function(String) onOptionSelected;

  const RelativeDropdownItems({
    super.key,
    required this.dropdownValue,
    required this.items,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),

        color: Colors.grey[200],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 8,
          dropdownColor: Colors.grey[200],
          isDense: true,
          onChanged: (String? newValue) {
            onOptionSelected(newValue!); // Call the callback function when an option is selected
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
