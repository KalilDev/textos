// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalil_widgets/constants.dart';

const double _kFrontClosedHeight = 56.0; // front layer height when closed
const double _kBackAppBarHeight = 42; // back layer (options) appbar height

class _TappableWhileStatusIs extends StatefulWidget {
  const _TappableWhileStatusIs(
    this.status, {
    Key key,
    this.controller,
    this.child,
  }) : super(key: key);

  final AnimationController controller;
  final AnimationStatus status;
  final Widget child;

  @override
  _TappableWhileStatusIsState createState() => _TappableWhileStatusIsState();
}

class _TappableWhileStatusIsState extends State<_TappableWhileStatusIs> {
  bool _active;

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener(_handleStatusChange);
    _active = widget.controller.status == widget.status;
  }

  @override
  void dispose() {
    widget.controller.removeStatusListener(_handleStatusChange);
    super.dispose();
  }

  void _handleStatusChange(AnimationStatus status) {
    final bool value = widget.controller.status == widget.status;
    if (_active != value) {
      setState(() {
        _active = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !_active,
      child: widget.child,
    );
  }
}

class _CrossFadeTransition extends AnimatedWidget {
  const _CrossFadeTransition({
    Key key,
    this.alignment = Alignment.center,
    Animation<double> progress,
    this.child0,
    this.child1,
  }) : super(key: key, listenable: progress);

  final AlignmentGeometry alignment;
  final Widget child0;
  final Widget child1;

  @override
  Widget build(BuildContext context) {
    final Animation<double> progress = listenable;

    final double opacity1 = CurvedAnimation(
      parent: ReverseAnimation(progress),
      curve: const Interval(0.5, 1.0),
    ).value;

    final double opacity2 = CurvedAnimation(
      parent: progress,
      curve: const Interval(0.5, 1.0),
    ).value;

    return Stack(
      alignment: alignment,
      children: <Widget>[
        Opacity(
          opacity: opacity1,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child1,
          ),
        ),
        Opacity(
          opacity: opacity2,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child0,
          ),
        ),
      ],
    );
  }
}

class _BackAppBar extends StatelessWidget {
  const _BackAppBar({
    Key key,
    Widget leading,
    @required this.title,
    this.trailing,
  })  : leading = leading ?? const SizedBox(width: 56.0),
        assert(title != null),
        super(key: key);

  final Widget leading;
  final Widget title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      Expanded(
        child: title,
      ),
    ];

    if (trailing != null) {
      children.add(
        Container(
          alignment: Alignment.center,
          width: 56.0,
          child: trailing,
        ),
      );
    }

    final ThemeData theme = Theme.of(context);
    final Color color = getTextColor(0.87,
        main: theme.colorScheme.onBackground, bg: theme.colorScheme.background);

    return IconTheme.merge(
      data: theme.primaryIconTheme.copyWith(color: color),
      child: DefaultTextStyle(
        style: theme.accentTextTheme.title.copyWith(color: color, fontWeight: FontWeight.bold),
        child: SizedBox(
          height: _kBackAppBarHeight,
          child: Row(
            children: <Widget>[
          Container(
          alignment: Alignment.center,
            height: _kBackAppBarHeight,
            width: _kBackAppBarHeight,
            margin: const EdgeInsets.only(left: 10.0),
            child: leading
          ),
              Container(
                  height: _kBackAppBarHeight,
                  child: title),
              Spacer(),
              Container(
                alignment: Alignment.center,
                height: _kBackAppBarHeight,
                width: _kBackAppBarHeight,
                margin: const EdgeInsets.only(right: 10.0),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).primaryColor.withAlpha(90),
                              shape: BoxShape.circle),
                          height: 2 * _kBackAppBarHeight / 3,
                          width: 2 * _kBackAppBarHeight / 3),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(80.0),
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      child: trailing,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Backdrop extends StatefulWidget {
  const Backdrop({
    this.frontAction,
    this.frontTitle,
    this.frontHeading,
    this.frontLayer,
    this.backTitle,
    this.backLayer,
  });

  final Widget frontAction;
  final Widget frontTitle;
  final Widget frontLayer;
  final Widget frontHeading;
  final Widget backTitle;
  final Widget backLayer;

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  Animation<double> _frontOpacity;

  static final Animatable<double> _frontOpacityTween =
      Tween<double>(begin: 0.2, end: 1.0).chain(
          CurveTween(curve: const Interval(0.0, 0.4, curve: Curves.easeInOut)));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
    _frontOpacity = _controller.drive(_frontOpacityTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _backdropHeight {
    // Warning: this can be safely called from the event handlers but it may
    // not be called at build time.
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return math.max(0.0, renderBox.size.height - _kFrontClosedHeight);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed)
      return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  void _toggleFrontLayer() {
    final AnimationStatus status = _controller.status;
    final bool isOpen = status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
    _controller.fling(velocity: isOpen ? -2.0 : 2.0);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> frontRelativeRect =
        _controller.drive(RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, constraints.biggest.height - _kFrontClosedHeight, 0.0, 0.0),
      end: const RelativeRect.fromLTRB(0.0, _kBackAppBarHeight, 0.0, 0.0),
    ));

    final List<Widget> layers = <Widget>[
      // Back layer
      Container(
        color: Color.alphaBlend(Theme.of(context).primaryColor.withAlpha(80),
            Theme.of(context).backgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Visibility(
                child: Container(
                    padding: const EdgeInsets.only(top: _kBackAppBarHeight),
                    child: widget.backLayer),
                visible: _controller.status != AnimationStatus.completed,
                maintainState: true,
              ),
            ),
          ],
        ),
      ),
      // Front layer
      PositionedTransition(
        rect: frontRelativeRect,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return PhysicalShape(
              elevation: 12.0,
              color: Theme.of(context).canvasColor,
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(_kBackAppBarHeight)))),
              clipBehavior: Clip.antiAlias,
              child: child,
            );
          },
          child: _TappableWhileStatusIs(
            AnimationStatus.completed,
            controller: _controller,
            child: FadeTransition(
              opacity: _frontOpacity,
              child: widget.frontLayer,
            ),
          ),
        ),
      ),
      _BackAppBar(
        leading: widget.frontAction,
        title: _CrossFadeTransition(
          progress: _controller,
          alignment: AlignmentDirectional.centerStart,
          child0: Semantics(namesRoute: true, child: widget.frontTitle),
          child1: Semantics(namesRoute: true, child: widget.backTitle),
        ),
        trailing: IconButton(
          onPressed: _toggleFrontLayer,
          tooltip: 'Toggle options page',
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _controller,
          ),
        ),
      ),
    ];

    // The front "heading" is a (typically transparent) widget that's stacked on
    // top of, and at the top of, the front layer. It adds support for dragging
    // the front layer up and down and for opening and closing the front layer
    // with a tap. It may obscure part of the front layer's topmost child.
    if (widget.frontHeading != null) {
      layers.add(
        PositionedTransition(
          rect: frontRelativeRect,
          child: ExcludeSemantics(
            child: Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleFrontLayer,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                child: widget.frontHeading,
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      key: _backdropKey,
      children: layers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildStack);
  }
}
