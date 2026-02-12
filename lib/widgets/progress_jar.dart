import 'package:flutter/material.dart';

/// Widget to display a jar filling with progress animation
class ProgressJar extends StatefulWidget {
  final double progress; // 0-100
  final double size;
  final Color fillColor;
  final Color emptyColor;

  const ProgressJar({
    Key? key,
    required this.progress,
    this.size = 150,
    this.fillColor = const Color(0xFF10b981),
    this.emptyColor = const Color(0xFFe5e7eb),
  }) : super(key: key);

  @override
  State<ProgressJar> createState() => _ProgressJarState();
}

class _ProgressJarState extends State<ProgressJar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.progress.clamp(0, 100),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressJar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress.clamp(0, 100),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _JarPainter(
            progress: _animation.value,
            fillColor: widget.fillColor,
            emptyColor: widget.emptyColor,
          ),
        );
      },
    );
  }
}

class _JarPainter extends CustomPainter {
  final double progress;
  final Color fillColor;
  final Color emptyColor;

  _JarPainter({
    required this.progress,
    required this.fillColor,
    required this.emptyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Jar outline
    final jarPaint = Paint()
      ..color = emptyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Jar cap (top small rectangle)
    canvas.drawRect(
      Rect.fromLTWH(width * 0.35, 0, width * 0.3, height * 0.08),
      Paint()
        ..color = Colors.grey[400]!
        ..style = PaintingStyle.fill,
    );

    // Jar body (rounded rectangle)
    final path = Path();
    path.moveTo(width * 0.1, height * 0.15);
    path.lineTo(width * 0.1, height * 0.7);
    path.quadraticBezierTo(width * 0.1, height * 0.9, width * 0.5, height * 0.9);
    path.quadraticBezierTo(width * 0.9, height * 0.9, width * 0.9, height * 0.7);
    path.lineTo(width * 0.9, height * 0.15);
    path.close();

    // Draw jar outline
    canvas.drawPath(path, jarPaint);

    // Draw fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final fillPercentage = progress / 100;
    final fillHeight = height * 0.75 * fillPercentage;

    // Create fill path
    final fillPath = Path();
    fillPath.moveTo(width * 0.1, height * 0.9 - fillHeight);
    fillPath.lineTo(width * 0.1, height * 0.7);
    fillPath.quadraticBezierTo(width * 0.1, height * 0.9, width * 0.5, height * 0.9);
    fillPath.quadraticBezierTo(width * 0.9, height * 0.9, width * 0.9, height * 0.7);
    fillPath.lineTo(width * 0.9, height * 0.9 - fillHeight);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);

    // Draw progress text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${progress.toStringAsFixed(0)}%',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (width - textPainter.width) / 2,
        (height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_JarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
