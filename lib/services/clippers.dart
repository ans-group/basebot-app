import 'package:flutter/material.dart';

class HeroClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final curveHeight = 70.0;
    final curveOffset = 0; //e.g. -0.15 would be 35%
    final Path path = Path();
    path.lineTo(0.0, size.height - curveHeight);

    var endPoint = Offset(size.width, size.height - curveHeight);
    var controlPoint = Offset(size.width * (.5 + curveOffset), size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
