import 'dart:math' as math;

import 'package:flutter/material.dart';

class ElevatedContainer extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color backgroundColor;
  final Color elevatedColor;
  final BoxConstraints constraints;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Matrix4 transform;

  ElevatedContainer(
      {Key key,
      this.alignment,
      this.padding,
      double width,
      double height,
      BoxConstraints constraints,
      this.margin,
      this.transform,
      this.child,
      this.backgroundColor,
      this.elevatedColor,
      @required this.elevation})
      : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(constraints == null || constraints.debugAssertIsValid()),
        constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        super(key: key);

  BoxDecoration materialCompliantElevation(
      {Color ev, Color bg, Brightness brightness}) {
    // 24.0dp is the highest elevation
    final fraction = elevation / 24.0;

    // Linear interpolate the BG with the elevation color
    final shadowColor = Color.lerp(bg, ev, fraction);

    // Offset is a linear interpolation from 0 to 10 with the fraction
    final offset = 10 * fraction >= 0 ? 10 * fraction : 0.0;
    if (brightness == Brightness.dark) {
      // 16% of 255 white is the highest elevation on dark mode
      final maxAlpha = 16 * 2.55;

      // Curve that approximates the material guidelines for dark mode
      const k = 2.0;
      final alpha = (1 - math.pow(math.e, -k * fraction * 2)) * maxAlpha;

      return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.alphaBlend(Colors.white.withAlpha(alpha.round()), bg));
    } else {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bg,
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                blurRadius: offset * 1.2,
                offset: Offset(offset, offset))
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: materialCompliantElevation(
          ev: elevatedColor != null
              ? elevatedColor
              : Theme.of(context).canvasColor,
          bg: backgroundColor != null
              ? backgroundColor
              : Theme.of(context).backgroundColor,
          brightness: Theme.of(context).brightness),
      constraints: constraints,
      alignment: alignment,
      padding: padding,
      margin: margin,
      transform: transform,
      child: child,
    );
  }
}
