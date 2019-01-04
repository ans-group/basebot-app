import 'package:flutter/material.dart';

class LoadingDot extends StatefulWidget {
  LoadingDot({this.delay});
  final double delay;
  _LoadingDotState createState() => _LoadingDotState();
}

class _LoadingDotState extends State<LoadingDot> with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(0.0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
          parent: animationController,
          curve: Interval(widget.delay, 1.0, curve: Curves.easeOut))),
      child: FadeTransition(
        opacity: CurvedAnimation(
            parent: animationController,
            curve: Interval(widget.delay, 1.0, curve: Curves.easeOut)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.5),
          width: 8.0,
          height: 8.0,
          decoration: new BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
