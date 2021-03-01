import 'package:flutter/material.dart';

class Clip extends StatelessWidget {
  final String message;
  Clip({@required this.message});
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return ClipPath(
      clipper: Cutter(),
      child: Container(
        height: _size.height / 2.3,
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Center(
            child: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white, letterSpacing: 1.5),
        )),
      ),
    );
  }
}

class Cutter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(0, size.height - size.width * 0.127)
      ..cubicTo(
          size.width * 0.25,
          size.height - size.width * 0.31,
          size.width - size.width * 0.25,
          size.height,
          size.width,
          size.height - size.width * 0.15)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
