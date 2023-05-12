import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShadeSliderThumb extends SliderComponentShape {
  const ShadeSliderThumb({
    required this.height,
    required this.width,
    required this.sliderValue,
  });

  final double height;
  final double width;
  final double sliderValue;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final innerPathColor = Paint()
      ..color = sliderValue == 0
          ? const Color.fromARGB(255, 32, 35, 42)
          : const Color.fromARGB(255, 221, 222, 224);
    final outerPathColor = Paint()
      ..color = const Color.fromARGB(255, 221, 222, 224)
      ..style = PaintingStyle.fill;
    final innerPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: width, height: height),
          Radius.circular(height),
        ),
      )
      ..close();
    final outerPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: width * 1.08,
            height: height * 1.08,
          ),
          Radius.circular(height),
        ),
      )
      ..close();
    canvas
      ..drawPath(outerPath, outerPathColor)
      ..drawPath(innerPath, innerPathColor);

    final span = TextSpan(
      style: GoogleFonts.sourceSansPro().copyWith(
        fontSize: height * 3 / 5,
        color: sliderValue == 0
            ? const Color.fromARGB(255, 157, 158, 160)
            : const Color.fromARGB(255, 1, 1, 3),
      ),
      text: sliderValue.round().toString(),
    );

    final tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    final textCenter = Offset(
      center.dx - (tp.width / 2),
      center.dy - (tp.height / 2),
    );

    tp.paint(canvas, textCenter);
  }
}
