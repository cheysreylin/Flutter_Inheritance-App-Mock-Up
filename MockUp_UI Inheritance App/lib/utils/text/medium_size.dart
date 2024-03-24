import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final TextOverflow overflow;

  const MediumText(
    {
      Key? key,
      this.color = const Color(0xFF4D4D4D),
      required this.text,
      this.size = 16,
      this.overflow = TextOverflow.ellipsis
    }
  ):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w600
      ),
    );
  }
}
