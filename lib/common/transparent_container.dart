import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class TransparentContainer extends StatelessWidget {
  final Widget child;
  const TransparentContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 40,
      blur: 5,
      alignment: Alignment.bottomCenter,
      border: 10,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.15),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Colors.transparent,
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: child,
      ),
    );
  }
}
