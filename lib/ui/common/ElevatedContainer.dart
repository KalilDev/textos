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
  final BorderRadius borderRadius;

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
        BorderRadius borderRadius,
        Color elevatedColor,
      @required this.elevation})
      : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(constraints == null || constraints.debugAssertIsValid()),
        constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        this.elevatedColor = elevatedColor != null ? elevatedColor : Color(
            0x50000000),
        this.borderRadius = borderRadius != null ? borderRadius : BorderRadius
            .circular(20.0),
        super(key: key);

  BoxDecoration materialCompliantElevation({Color bg, Brightness brightness}) {
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
          borderRadius: borderRadius,
          color: bg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      alignment: alignment,
      transform: transform,
      margin: margin,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        color: Colors.transparent,
        elevation: elevation,
        child: Container(
          decoration: materialCompliantElevation(
              bg: backgroundColor != null
                  ? backgroundColor
                  : Theme
                  .of(context)
                  .backgroundColor,
              brightness: Theme
                  .of(context)
                  .brightness),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
