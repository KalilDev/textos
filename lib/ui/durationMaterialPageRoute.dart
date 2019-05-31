import 'package:flutter/material.dart';
import 'package:textos/constants.dart';

class DurationMaterialPageRoute<T extends dynamic>
    extends MaterialPageRoute<T> {
  DurationMaterialPageRoute(
      {WidgetBuilder builder, RouteSettings settings, Duration duration})
      : duration = (duration != null) ? duration : durationAnimationRoute,
        super(builder: builder, settings: settings);
  final Duration duration;

  @override
  Duration get transitionDuration => duration;
}
