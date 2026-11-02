import 'dart:math';
import 'package:flutter/material.dart';

class ButterflyWidget extends StatefulWidget {
  final double size;

  const ButterflyWidget({super.key, this.size = 28});

  @override
  State<ButterflyWidget> createState() => _ButterflyWidgetState();
}

class _ButterflyWidgetState extends State<ButterflyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Wing flapping scale transformation
        final flap = 0.5 + 0.5 * sin(_controller.value * pi);
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(0.2 * sin(_controller.value * pi))
            ..scale(flap, 1.0),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.flutter_dash, // charming winged creature / butterfly
              color: Color(0xFF0284C7),
              size: 26,
            ),
          ),
        );
      },
    );
  }
}
