import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key,
      required this.lavel,
      this.fonntSize =18,
      this.color,
      this.fontWeight});

  final String lavel;
  final double fonntSize;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      lavel,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fonntSize,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
