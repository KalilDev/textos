import 'package:flutter/material.dart';

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (animation.status == AnimationStatus.reverse) {
      Animation curved = new CurvedAnimation(
          parent: animation, curve: Curves.easeInOut);
      return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child);
    }
    return FadeTransition(opacity: animation, child: child);
  }
}
