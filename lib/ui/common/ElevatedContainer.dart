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

    // Offset is a linear interpolation from 0 to 10 with the fraction
    final offset = 2 * fraction >= 0 ? 2 * fraction : 0.0;
    final shadowColor = offset < 0.04 ? Color.lerp(
        Color(0x50000000), Colors.transparent, fraction / 0.04) : Color(
        0x50000000);
    if (brightness == Brightness.dark) {
      // Curve that approximates the material guidelines for dark mode
      double k;
      double adjust = 0;
      if (3.5 > elevation) {
        k = -6;
        if (elevation < 2.5 && elevation >= 1.0) adjust = 1;
      } else if (3.5 < elevation && elevation < 7.0) {
        k = -5;
      } else if (elevation > 7.0) {
        k = -4;
      }
      final double toSixteen = 16 / (24 * (1 - math.pow(math.e, k * 1)));
      final alpha = (24 * (1 - math.pow(math.e, k * elevation / 24)) *
          toSixteen) + adjust;

      return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.alphaBlend(
              Colors.white.withAlpha((alpha * 2.55).round()), bg));
    } else {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bg,
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                blurRadius: offset * 1.2,
                offset: Offset(offset, offset)),
            BoxShadow(
                color: shadowColor,
                blurRadius: offset * 1.2,
                offset: Offset(-offset, -offset)),
            BoxShadow(
                color: shadowColor,
                blurRadius: offset * 1.2,
                offset: Offset(-offset, offset)),
            BoxShadow(
                color: shadowColor,
                blurRadius: offset * 1.2,
                offset: Offset(offset, -offset))
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: materialCompliantElevation(
          ev: elevatedColor != null
              ? elevatedColor
              : Theme
              .of(context)
              .primaryColor,
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
