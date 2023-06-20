import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  final AnimationController animationController;

  const AnimatedLogo({
    super.key,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: animationController.value,
          child: Image.asset(
            'assets/images/logo.jpg',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
