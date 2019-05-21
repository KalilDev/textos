import 'package:flutter/material.dart';
import 'package:textos/constants.dart';

class SlideRoute<T> extends MaterialPageRoute<T> {
  SlideRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => Constants.durationAnimationRoute;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animation<double> curved =
    new CurvedAnimation(parent: animation, curve: Curves.easeInOut);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(curved),
      child: child,
    );
  }
}
