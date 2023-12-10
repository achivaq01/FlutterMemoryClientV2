import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Import material.dart for the TextStyle class
import 'package:stroke_text/stroke_text.dart';

class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        Key? key, // Use Key? instead of super.key
        required this.gradient,
        required this.style,
        required this.strokeColor,
        required this.strokeWidth,
      }) : super(key: key);

  final String text;
  final TextStyle style;
  final Gradient gradient;
  final Color strokeColor;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: StrokeText(
        text: text,
        textStyle: style,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
