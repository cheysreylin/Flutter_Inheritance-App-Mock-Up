import 'package:flutter/material.dart';

class DropDownItem extends StatelessWidget {
  const DropDownItem(
      {Key? key,
      required this.onOptionSelected,
      required String dropdownValue,
      required List<String> items})
      : super(key: key);

  final Function(String) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Public';

    return Container(
      height: 30,
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
            onOptionSelected(newValue ??
                ''); // Call the callback function when option is selected
          },
          items: <String>['Public', 'Private', 'Friends']
              .map<DropdownMenuItem<String>>((String value) {
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
