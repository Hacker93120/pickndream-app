import 'package:flutter/material.dart';

class WaveHeader extends StatelessWidget {
  final Widget child;
  final double height;

  const WaveHeader({
    Key? key,
    required this.child,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade800, Colors.blue.shade400],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 60),
              painter: WavePainter(),
            ),
          ),
          Center(child: child),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    path.moveTo(0, size.height * 0.5);
    
    path.quadraticBezierTo(
      size.width * 0.25, 0,
      size.width * 0.5, size.height * 0.3,
    );
    
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.6,
      size.width, size.height * 0.2,
    );
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
