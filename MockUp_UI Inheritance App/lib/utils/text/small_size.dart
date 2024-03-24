import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextStyle textStyle; // Changed to TextStyle

  const SmallText({
    Key? key,
    this.color = const Color(0xFF2D2D2D),
    required this.text,
    this.size = 13,
    this.fontWeight = FontWeight.normal,
    this.textAlign,
    TextStyle? textStyle, // Changed to TextStyle
  })  : textStyle = textStyle ??
            const TextStyle(
                fontFamily: 'RobotoMono'), // Use RobotoMono if not specified
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        fontFamily: textStyle.fontFamily,
      ),
      textAlign: textAlign,
    );
  }
}
