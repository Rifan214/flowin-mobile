import 'package:flutter/material.dart';

/// Organic asymmetric coastal wave clipper inspired by Wonderous `CurvedTopClipper`.
class OrganicWaveClipper extends CustomClipper<Path> {
  const OrganicWaveClipper({this.waveDepth = 36});

  final double waveDepth;

  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - waveDepth);
    path.cubicTo(
      size.width * 0.28,
      size.height,
      size.width * 0.65,
      size.height - waveDepth * 1.6,
      size.width,
      size.height - waveDepth * 0.45,
    );
    path
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant OrganicWaveClipper oldClipper) =>
      oldClipper.waveDepth != waveDepth;
}

