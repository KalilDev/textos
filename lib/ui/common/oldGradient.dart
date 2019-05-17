// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' as ui show Gradient, lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _ColorsAndStops {
  _ColorsAndStops(this.colors, this.stops);

  final List<Color> colors;
  final List<double> stops;
}

_ColorsAndStops _interpolateColorsAndStops(List<Color> aColors,
    List<double> aStops, List<Color> bColors, List<double> bStops, double t) {
  assert(aColors.length == bColors.length,
      'Cannot interpolate between two gradients with a different number of colors.');
  assert((aStops == null && aColors.length == 2) ||
      (aStops != null && aStops.length == aColors.length));
  assert((bStops == null && bColors.length == 2) ||
      (bStops != null && bStops.length == bColors.length));
  final List<Color> interpolatedColors = <Color>[];
  for (int i = 0; i < aColors.length; i += 1)
    interpolatedColors.add(Color.lerp(aColors[i], bColors[i], t));
  List<double> interpolatedStops;
  if (aStops != null || bStops != null) {
    aStops ??= const <double>[0.0, 1.0];
    bStops ??= const <double>[0.0, 1.0];
    assert(aStops.length == bStops.length);
    interpolatedStops = <double>[];
    for (int i = 0; i < aStops.length; i += 1)
      interpolatedStops
          .add(ui.lerpDouble(aStops[i], bStops[i], t).clamp(0.0, 1.0));
  }
  return _ColorsAndStops(interpolatedColors, interpolatedStops);
}

@immutable
abstract class Gradient {
  const Gradient({
    @required this.colors,
    this.stops,
  }) : assert(colors != null);

  final List<Color> colors;

  final List<double> stops;

  List<double> _impliedStops() {
    if (stops != null) return stops;
    if (colors.length == 2) return null;
    assert(colors.length >= 2, 'colors list must have at least two colors');
    final double separation = 1.0 / (colors.length - 1);
    return List<double>.generate(
      colors.length,
      (int index) => index * separation,
      growable: false,
    );
  }

  Shader createShader(Rect rect, {TextDirection textDirection});

  Gradient scale(double factor);

  @protected
  Gradient lerpFrom(Gradient a, double t) {
    if (a == null) return scale(t);
    return null;
  }

  @protected
  Gradient lerpTo(Gradient b, double t) {
    if (b == null) return scale(1.0 - t);
    return null;
  }

  static Gradient lerp(Gradient a, Gradient b, double t) {
    assert(t != null);
    Gradient result;
    if (b != null)
      result = b.lerpFrom(a, t); // if a is null, this must return non-null
    if (result == null && a != null)
      result = a.lerpTo(b, t); // if b is null, this must return non-null
    if (result != null) return result;
    if (a == null && b == null) return null;
    assert(a != null && b != null);
    return t < 0.5 ? a.scale(1.0 - (t * 2.0)) : b.scale((t - 0.5) * 2.0);
  }
}

class LinearGradient extends Gradient {
  const LinearGradient({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    @required List<Color> colors,
    List<double> stops,
    this.tileMode = TileMode.clamp,
  })  : assert(begin != null),
        assert(end != null),
        assert(tileMode != null),
        super(colors: colors, stops: stops);

  final AlignmentGeometry begin;

  final AlignmentGeometry end;

  final TileMode tileMode;

  @override
  Shader createShader(Rect rect, {TextDirection textDirection}) {
    return ui.Gradient.linear(
      begin.resolve(textDirection).withinRect(rect),
      end.resolve(textDirection).withinRect(rect),
      colors,
      _impliedStops(),
      tileMode,
    );
  }

  @override
  LinearGradient scale(double factor) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors
          .map<Color>((Color color) => Color.lerp(null, color, factor))
          .toList(),
      stops: stops,
      tileMode: tileMode,
    );
  }

  @override
  Gradient lerpFrom(Gradient a, double t) {
    if (a == null || (a is LinearGradient && a.colors.length == colors.length))
      return LinearGradient.lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  Gradient lerpTo(Gradient b, double t) {
    if (b == null || (b is LinearGradient && b.colors.length == colors.length))
      return LinearGradient.lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  static LinearGradient lerp(LinearGradient a, LinearGradient b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    if (a == null) return b.scale(t);
    if (b == null) return a.scale(1.0 - t);
    final _ColorsAndStops interpolated =
        _interpolateColorsAndStops(a.colors, a.stops, b.colors, b.stops, t);
    return LinearGradient(
      begin: AlignmentGeometry.lerp(a.begin, b.begin, t),
      end: AlignmentGeometry.lerp(a.end, b.end, t),
      colors: interpolated.colors,
      stops: interpolated.stops,
      tileMode: t < 0.5
          ? a.tileMode
          : b.tileMode, // TODO(ianh): interpolate tile mode
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final LinearGradient typedOther = other;
    if (begin != typedOther.begin ||
        end != typedOther.end ||
        tileMode != typedOther.tileMode ||
        colors?.length != typedOther.colors?.length ||
        stops?.length != typedOther.stops?.length) return false;
    if (colors != null) {
      assert(typedOther.colors != null);
      assert(colors.length == typedOther.colors.length);
      for (int i = 0; i < colors.length; i += 1) {
        if (colors[i] != typedOther.colors[i]) return false;
      }
    }
    if (stops != null) {
      assert(typedOther.stops != null);
      assert(stops.length == typedOther.stops.length);
      for (int i = 0; i < stops.length; i += 1) {
        if (stops[i] != typedOther.stops[i]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode =>
      hashValues(begin, end, tileMode, hashList(colors), hashList(stops));

  @override
  String toString() {
    return '$runtimeType($begin, $end, $colors, $stops, $tileMode)';
  }
}

class RadialGradient extends Gradient {
  const RadialGradient(
      {this.center = Alignment.center,
      this.radius = 0.5,
      @required List<Color> colors,
      List<double> stops,
      this.tileMode = TileMode.clamp,
      this.focal,
      this.focalRadius = 0.0})
      : assert(center != null),
        assert(radius != null),
        assert(tileMode != null),
        assert(focalRadius != null),
        super(colors: colors, stops: stops);

  final AlignmentGeometry center;
  final double radius;
  final TileMode tileMode;
  final AlignmentGeometry focal;
  final double focalRadius;

  @override
  Shader createShader(Rect rect, {TextDirection textDirection}) {
    return ui.Gradient.radial(
      center.resolve(textDirection).withinRect(rect),
      radius * rect.shortestSide,
      colors,
      _impliedStops(),
      tileMode,
      null,
      // transform
      focal == null ? null : focal.resolve(textDirection).withinRect(rect),
      focalRadius * rect.shortestSide,
    );
  }

  @override
  RadialGradient scale(double factor) {
    return RadialGradient(
        center: center,
        radius: radius,
        colors: colors
            .map<Color>((Color color) => Color.lerp(null, color, factor))
            .toList(),
        stops: stops,
        tileMode: tileMode,
        focal: focal,
        focalRadius: focalRadius);
  }

  @override
  Gradient lerpFrom(Gradient a, double t) {
    if (a == null || (a is RadialGradient && a.colors.length == colors.length))
      return RadialGradient.lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  Gradient lerpTo(Gradient b, double t) {
    if (b == null || (b is RadialGradient && b.colors.length == colors.length))
      return RadialGradient.lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  static RadialGradient lerp(RadialGradient a, RadialGradient b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    if (a == null) return b.scale(t);
    if (b == null) return a.scale(1.0 - t);
    final _ColorsAndStops interpolated =
        _interpolateColorsAndStops(a.colors, a.stops, b.colors, b.stops, t);
    return RadialGradient(
      center: AlignmentGeometry.lerp(a.center, b.center, t),
      radius: math.max(0.0, ui.lerpDouble(a.radius, b.radius, t)),
      colors: interpolated.colors,
      stops: interpolated.stops,
      tileMode: t < 0.5 ? a.tileMode : b.tileMode,
      // TODO(ianh): interpolate tile mode
      focal: AlignmentGeometry.lerp(a.focal, b.focal, t),
      focalRadius:
          math.max(0.0, ui.lerpDouble(a.focalRadius, b.focalRadius, t)),
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final RadialGradient typedOther = other;
    if (center != typedOther.center ||
        radius != typedOther.radius ||
        tileMode != typedOther.tileMode ||
        colors?.length != typedOther.colors?.length ||
        stops?.length != typedOther.stops?.length ||
        focal != typedOther.focal ||
        focalRadius != typedOther.focalRadius) return false;
    if (colors != null) {
      assert(typedOther.colors != null);
      assert(colors.length == typedOther.colors.length);
      for (int i = 0; i < colors.length; i += 1) {
        if (colors[i] != typedOther.colors[i]) return false;
      }
    }
    if (stops != null) {
      assert(typedOther.stops != null);
      assert(stops.length == typedOther.stops.length);
      for (int i = 0; i < stops.length; i += 1) {
        if (stops[i] != typedOther.stops[i]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => hashValues(center, radius, tileMode, hashList(colors),
      hashList(stops), focal, focalRadius);

  @override
  String toString() {
    return '$runtimeType($center, $radius, $colors, $stops, $tileMode, $focal, $focalRadius)';
  }
}

class SweepGradient extends Gradient {
  const SweepGradient({
    this.center = Alignment.center,
    this.startAngle = 0.0,
    this.endAngle = math.pi * 2,
    @required List<Color> colors,
    List<double> stops,
    this.tileMode = TileMode.clamp,
  })  : assert(center != null),
        assert(startAngle != null),
        assert(endAngle != null),
        assert(tileMode != null),
        super(colors: colors, stops: stops);

  final AlignmentGeometry center;

  final double startAngle;

  final double endAngle;
  final TileMode tileMode;

  @override
  Shader createShader(Rect rect, {TextDirection textDirection}) {
    return ui.Gradient.sweep(
      center.resolve(textDirection).withinRect(rect),
      colors,
      _impliedStops(),
      tileMode,
      startAngle,
      endAngle,
    );
  }

  @override
  SweepGradient scale(double factor) {
    return SweepGradient(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      colors: colors
          .map<Color>((Color color) => Color.lerp(null, color, factor))
          .toList(),
      stops: stops,
      tileMode: tileMode,
    );
  }

  @override
  Gradient lerpFrom(Gradient a, double t) {
    if (a == null || (a is SweepGradient && a.colors.length == colors.length))
      return SweepGradient.lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  Gradient lerpTo(Gradient b, double t) {
    if (b == null || (b is SweepGradient && b.colors.length == colors.length))
      return SweepGradient.lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  static SweepGradient lerp(SweepGradient a, SweepGradient b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    if (a == null) return b.scale(t);
    if (b == null) return a.scale(1.0 - t);
    final _ColorsAndStops interpolated =
        _interpolateColorsAndStops(a.colors, a.stops, b.colors, b.stops, t);
    return SweepGradient(
      center: AlignmentGeometry.lerp(a.center, b.center, t),
      startAngle: math.max(0.0, ui.lerpDouble(a.startAngle, b.startAngle, t)),
      endAngle: math.max(0.0, ui.lerpDouble(a.endAngle, b.endAngle, t)),
      colors: interpolated.colors,
      stops: interpolated.stops,
      tileMode: t < 0.5
          ? a.tileMode
          : b.tileMode, // TODO(ianh): interpolate tile mode
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final SweepGradient typedOther = other;
    if (center != typedOther.center ||
        startAngle != typedOther.startAngle ||
        endAngle != typedOther.endAngle ||
        tileMode != typedOther.tileMode ||
        colors?.length != typedOther.colors?.length ||
        stops?.length != typedOther.stops?.length) return false;
    if (colors != null) {
      assert(typedOther.colors != null);
      assert(colors.length == typedOther.colors.length);
      for (int i = 0; i < colors.length; i += 1) {
        if (colors[i] != typedOther.colors[i]) return false;
      }
    }
    if (stops != null) {
      assert(typedOther.stops != null);
      assert(stops.length == typedOther.stops.length);
      for (int i = 0; i < stops.length; i += 1) {
        if (stops[i] != typedOther.stops[i]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => hashValues(center, startAngle, endAngle, tileMode,
      hashList(colors), hashList(stops));

  @override
  String toString() {
    return '$runtimeType($center, $startAngle, $endAngle, $colors, $stops, $tileMode)';
  }
}

// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class BoxDecoration extends Decoration {
  const BoxDecoration({
    this.color,
    this.image,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape = BoxShape.rectangle,
  })  : assert(shape != null),
        assert(
            backgroundBlendMode == null || color != null || gradient != null,
            'backgroundBlendMode applies to BoxDecoration\'s background color or '
            'gradient, but no color or gradient was provided.');

  @override
  bool debugAssertIsValid() {
    assert(shape != BoxShape.circle ||
        borderRadius == null); // Can't have a border radius if you're a circle.
    return super.debugAssertIsValid();
  }

  final Color color;
  final DecorationImage image;
  final BoxBorder border;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow> boxShadow;
  final Gradient gradient;
  final BlendMode backgroundBlendMode;
  final BoxShape shape;

  @override
  EdgeInsetsGeometry get padding => border?.dimensions;

  /// Returns a new box decoration that is scaled by the given factor.
  BoxDecoration scale(double factor) {
    return BoxDecoration(
      color: Color.lerp(null, color, factor),
      image: image,
      // TODO(ianh): fade the image from transparent
      border: BoxBorder.lerp(null, border, factor),
      borderRadius: BorderRadiusGeometry.lerp(null, borderRadius, factor),
      boxShadow: BoxShadow.lerpList(null, boxShadow, factor),
      gradient: gradient?.scale(factor),
      shape: shape,
    );
  }

  @override
  bool get isComplex => boxShadow != null;

  @override
  BoxDecoration lerpFrom(Decoration a, double t) {
    if (a == null) return scale(t);
    if (a is BoxDecoration) return BoxDecoration.lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  BoxDecoration lerpTo(Decoration b, double t) {
    if (b == null) return scale(1.0 - t);
    if (b is BoxDecoration) return BoxDecoration.lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  static BoxDecoration lerp(BoxDecoration a, BoxDecoration b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    if (a == null) return b.scale(t);
    if (b == null) return a.scale(1.0 - t);
    if (t == 0.0) return a;
    if (t == 1.0) return b;
    return BoxDecoration(
      color: Color.lerp(a.color, b.color, t),
      image: t < 0.5 ? a.image : b.image,
      // TODO(ianh): cross-fade the image
      border: BoxBorder.lerp(a.border, b.border, t),
      borderRadius:
          BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      shape: t < 0.5 ? a.shape : b.shape,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final BoxDecoration typedOther = other;
    return color == typedOther.color &&
        image == typedOther.image &&
        border == typedOther.border &&
        borderRadius == typedOther.borderRadius &&
        boxShadow == typedOther.boxShadow &&
        gradient == typedOther.gradient &&
        shape == typedOther.shape;
  }

  @override
  int get hashCode {
    return hashValues(
      color,
      image,
      border,
      borderRadius,
      boxShadow,
      gradient,
      shape,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.whitespace
      ..emptyBodyDescription = '<no decorations specified>';

    properties
        .add(DiagnosticsProperty<Color>('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty<DecorationImage>('image', image,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<BoxBorder>('border', border, defaultValue: null));
    properties.add(DiagnosticsProperty<BorderRadiusGeometry>(
        'borderRadius', borderRadius,
        defaultValue: null));
    properties.add(IterableProperty<BoxShadow>('boxShadow', boxShadow,
        defaultValue: null, style: DiagnosticsTreeStyle.whitespace));
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(EnumProperty<BoxShape>('shape', shape,
        defaultValue: BoxShape.rectangle));
  }

  @override
  bool hitTest(Size size, Offset position, {TextDirection textDirection}) {
    assert(shape != null);
    assert((Offset.zero & size).contains(position));
    switch (shape) {
      case BoxShape.rectangle:
        if (borderRadius != null) {
          final RRect bounds =
              borderRadius.resolve(textDirection).toRRect(Offset.zero & size);
          return bounds.contains(position);
        }
        return true;
      case BoxShape.circle:
        // Circles are inscribed into our smallest dimension.
        final Offset center = size.center(Offset.zero);
        final double distance = (position - center).distance;
        return distance <= math.min(size.width, size.height) / 2.0;
    }
    assert(shape != null);
    return null;
  }

  @override
  _BoxDecorationPainter createBoxPainter([VoidCallback onChanged]) {
    assert(onChanged != null || image == null);
    return _BoxDecorationPainter(this, onChanged);
  }
}

/// An object that paints a [BoxDecoration] into a canvas.
class _BoxDecorationPainter extends BoxPainter {
  _BoxDecorationPainter(this._decoration, VoidCallback onChanged)
      : assert(_decoration != null),
        super(onChanged);

  final BoxDecoration _decoration;

  Paint _cachedBackgroundPaint;
  Rect _rectForCachedBackgroundPaint;

  Paint _getBackgroundPaint(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(
        _decoration.gradient != null || _rectForCachedBackgroundPaint == null);

    if (_cachedBackgroundPaint == null ||
        (_decoration.gradient != null &&
            _rectForCachedBackgroundPaint != rect)) {
      final Paint paint = Paint();
      if (_decoration.backgroundBlendMode != null)
        paint.blendMode = _decoration.backgroundBlendMode;
      if (_decoration.color != null) paint.color = _decoration.color;
      if (_decoration.gradient != null) {
        paint.shader = _decoration.gradient
            .createShader(rect, textDirection: textDirection);
        _rectForCachedBackgroundPaint = rect;
      }
      _cachedBackgroundPaint = paint;
    }

    return _cachedBackgroundPaint;
  }

  void _paintBox(
      Canvas canvas, Rect rect, Paint paint, TextDirection textDirection) {
    switch (_decoration.shape) {
      case BoxShape.circle:
        assert(_decoration.borderRadius == null);
        final Offset center = rect.center;
        final double radius = rect.shortestSide / 2.0;
        canvas.drawCircle(center, radius, paint);
        break;
      case BoxShape.rectangle:
        if (_decoration.borderRadius == null) {
          canvas.drawRect(rect, paint);
        } else {
          canvas.drawRRect(
              _decoration.borderRadius.resolve(textDirection).toRRect(rect),
              paint);
        }
        break;
    }
  }

  void _paintShadows(Canvas canvas, Rect rect, TextDirection textDirection) {
    if (_decoration.boxShadow == null) return;
    for (BoxShadow boxShadow in _decoration.boxShadow) {
      final Paint paint = boxShadow.toPaint();
      final Rect bounds =
          rect.shift(boxShadow.offset).inflate(boxShadow.spreadRadius);
      _paintBox(canvas, bounds, paint, textDirection);
    }
  }

  void _paintBackgroundColor(
      Canvas canvas, Rect rect, TextDirection textDirection) {
    if (_decoration.color != null || _decoration.gradient != null)
      _paintBox(canvas, rect, _getBackgroundPaint(rect, textDirection),
          textDirection);
  }

  DecorationImagePainter _imagePainter;

  void _paintBackgroundImage(
      Canvas canvas, Rect rect, ImageConfiguration configuration) {
    if (_decoration.image == null) return;
    _imagePainter ??= _decoration.image.createPainter(onChanged);
    Path clipPath;
    switch (_decoration.shape) {
      case BoxShape.circle:
        clipPath = Path()..addOval(rect);
        break;
      case BoxShape.rectangle:
        if (_decoration.borderRadius != null)
          clipPath = Path()
            ..addRRect(_decoration.borderRadius
                .resolve(configuration.textDirection)
                .toRRect(rect));
        break;
    }
    _imagePainter.paint(canvas, rect, clipPath, configuration);
  }

  @override
  void dispose() {
    _imagePainter?.dispose();
    super.dispose();
  }

  /// Paint the box decoration into the given location on the given canvas
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    _paintShadows(canvas, rect, textDirection);
    _paintBackgroundColor(canvas, rect, textDirection);
    _paintBackgroundImage(canvas, rect, configuration);
    _decoration.border?.paint(
      canvas,
      rect,
      shape: _decoration.shape,
      borderRadius: _decoration.borderRadius,
      textDirection: configuration.textDirection,
    );
  }

  @override
  String toString() {
    return 'BoxPainter for $_decoration';
  }
}
