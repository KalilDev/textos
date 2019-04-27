import 'dart:ui';

import 'package:flutter/material.dart';

class BlurOverlay extends StatelessWidget {
  final Widget child;
  final int radius;
  final bool enabled;
  final double intensity;

  BlurOverlay(
      {@required this.child, this.radius = 0, @required this.enabled, this.intensity = 1.0});

  Widget blur(BuildContext context) {
    final sigma = 4 * intensity;
    if (enabled) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
              color: Theme.of(context).backgroundColor.withAlpha(140),
              child: child));
    } else {
      return Container(
          color: Theme.of(context).backgroundColor.withAlpha(200),
          child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (radius) {
      case 0:
        return ClipRect(clipBehavior: Clip.hardEdge, child: blur(context));
        break;
      case 100:
        return ClipOval(clipBehavior: Clip.hardEdge, child: blur(context));
        break;
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(radius.toDouble()),
        clipBehavior: Clip.hardEdge,
        child: blur(context));
  }
}
