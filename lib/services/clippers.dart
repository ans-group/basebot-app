import 'package:flutter/material.dart';

class HeaderClipper extends CustomClipper<Path> {
  double _curveHeight;

  HeaderClipper(this._curveHeight);

  @override
  Path getClip(Size size) {
    final curveOffset = 0; //e.g. -0.15 would be 35%
    final Path path = Path();
    path.lineTo(0.0, size.height - _curveHeight);

    var endPoint = Offset(size.width, size.height - _curveHeight);
    var controlPoint =
        Offset(size.width * (.5 + curveOffset), size.height + _curveHeight);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
