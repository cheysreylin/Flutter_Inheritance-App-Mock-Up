import 'package:flutter/material.dart';

class TextButtonStyling extends StatelessWidget {
  const TextButtonStyling({
    Key? key,
    required this.color,
    required this.width,
    required this.height,
    required this.text,
    this.onPressed,
    this.borderRadius = 9.0,
    required this.textColor,
    this.icon, // Add icon parameter
    this.iconColor, // Add iconColor parameter
  }) : super(key: key);

  final double borderRadius;
  final Color color;
  final double height;
  final VoidCallback? onPressed;
  final String text;
  final Color textColor; // Added textColor property
  final double width;
  final IconData? icon; // Define icon parameter
  final Color? iconColor; // Define iconColor parameter

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor, // Use the specified textColor
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
