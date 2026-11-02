import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundSceneryWidget extends StatelessWidget {
  final String theme;
  final Widget child;

  const BackgroundSceneryWidget({
    super.key,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Scenic Canvas
        Positioned.fill(
          child: CustomPaint(
            painter: ScenicPainter(theme: theme),
          ),
        ),
        // Child content (game screens, overlays)
        child,
      ],
    );
  }
}

class ScenicPainter extends CustomPainter {
  final String theme;

  ScenicPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    if (theme == 'sea') {
      _paintSea(canvas, size);
    } else if (theme == 'autumn') {
      _paintAutumn(canvas, size);
    } else if (theme == 'twilight') {
      _paintTwilight(canvas, size);
    } else {
      _paintForest(canvas, size);
    }
  }

  void _paintForest(Canvas canvas, Size size) {
    // Golden autumn forest path matching reference video
    final skyGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFE5A93C),
        Color(0xFFCE7E15),
        Color(0xFF9E4B07),
        Color(0xFF6B3008),
      ],
      stops: [0.0, 0.35, 0.7, 1.0],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = skyGradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Sun glow at center vanishing point
    final sunGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.9),
          const Color(0xFFFFD54F).withOpacity(0.5),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.42),
        radius: size.width * 0.4,
      ));
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.42),
      size.width * 0.4,
      sunGlow,
    );

    // Forest perspective path
    final pathPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFC4863B).withOpacity(0.7),
          const Color(0xFF8B4513).withOpacity(0.9),
          const Color(0xFF5C2C16),
        ],
      ).createShader(rect);

    final road = Path()
      ..moveTo(size.width * 0.45, size.height * 0.45)
      ..lineTo(size.width * 0.55, size.height * 0.45)
      ..lineTo(size.width * 0.85, size.height)
      ..lineTo(size.width * 0.15, size.height)
      ..close();
    canvas.drawPath(road, pathPaint);

    // Left and Right tree silhouettes / foliage clusters
    _drawFoliageClusters(canvas, size, const Color(0xFFD97706));
    _drawFoliageClusters(canvas, size, const Color(0xFFB45309));
    _drawTreeTrunks(canvas, size);
  }

  void _paintSea(Canvas canvas, Size size) {
    // Azure sea with dramatic cliffs
    final seaGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF38BDF8),
        Color(0xFF0284C7),
        Color(0xFF0D9488),
        Color(0xFF042F2E),
      ],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = seaGradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Sunlight reflection
    final sunGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.8),
          Colors.cyan.withOpacity(0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.25),
        radius: size.width * 0.5,
      ));
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.25),
      size.width * 0.5,
      sunGlow,
    );

    // Mountain silhouettes in background
    final mountainPaint = Paint()..color = const Color(0xFF0F766E).withOpacity(0.5);
    final mPath = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.3, size.height * 0.35)
      ..lineTo(size.width * 0.6, size.height * 0.48)
      ..lineTo(size.width, size.height * 0.38)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(mPath, mountainPaint);
  }

  void _paintAutumn(Canvas canvas, Size size) {
    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFF59E0B),
        Color(0xFFD97706),
        Color(0xFF9A3412),
        Color(0xFF431407),
      ],
    );
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
    _drawFoliageClusters(canvas, size, const Color(0xFFEA580C));
  }

  void _paintTwilight(Canvas canvas, Size size) {
    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF1E1B4B),
        Color(0xFF312E81),
        Color(0xFF4C1D95),
        Color(0xFF0F172A),
      ],
    );
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    // Stars
    final starPaint = Paint()..color = Colors.white.withOpacity(0.8);
    final random = Random(42);
    for (int i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * (size.height * 0.6);
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 2 + 0.8, starPaint);
    }
  }

  void _drawFoliageClusters(Canvas canvas, Size size, Color color) {
    final paint = Paint()..color = color.withOpacity(0.25);
    final random = Random(123);
    for (int i = 0; i < 20; i++) {
      final x = random.nextBool()
          ? random.nextDouble() * (size.width * 0.3)
          : size.width - (random.nextDouble() * (size.width * 0.3));
      final y = size.height * 0.1 + random.nextDouble() * (size.height * 0.7);
      final r = 30 + random.nextDouble() * 50;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  void _drawTreeTrunks(Canvas canvas, Size size) {
    final trunkPaint = Paint()
      ..color = const Color(0xFF3E2723).withOpacity(0.4)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.9),
      Offset(size.width * 0.18, size.height * 0.3),
      trunkPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.88, size.height * 0.9),
      Offset(size.width * 0.82, size.height * 0.3),
      trunkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScenicPainter oldDelegate) =>
      oldDelegate.theme != theme;
}
