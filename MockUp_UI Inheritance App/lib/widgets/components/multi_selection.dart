import 'package:flutter/material.dart';
import 'package:inheritance_app/utils/theme/theme.dart';
import 'package:inheritance_app/widgets/components/button.dart';

class MultiSelectionOption extends StatefulWidget {
  final List<String> items;

  const MultiSelectionOption({Key? key, required this.items}) : super(key: key);

  @override
  State<MultiSelectionOption> createState() => _MultiSelectionOptionState();
}

class _MultiSelectionOptionState extends State<MultiSelectionOption> {
  // create variable to hold the selected value
  final List<String> _selectedItems = [];

  // This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this functions is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

  // this function is called  when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("    Select selling options", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                  value: _selectedItems.contains(item),
                  title: Text(item),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (isChecked) => _itemChange(item, isChecked!)))
              .toList(),
        ),
      ),
      actions: [
        TextButtonStyling(
          color: AppColor.Red,
          width: 110,
          height: 30,
          text: "Cancal",
          onPressed: _cancel,
          textColor: AppColor.White,
        ),
        TextButtonStyling(
          color: AppColor.Purple,
          width: 110,
          height: 30,
          text: "Submit",
          onPressed: _submit,
          textColor: AppColor.White,
        )
      ],
    );
  }
}
