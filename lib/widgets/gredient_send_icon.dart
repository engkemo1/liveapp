import 'package:flutter/material.dart';

import '../global/constants.dart';

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => GRADIENT.createShader(bounds),
      child: child,
    );
  }
}