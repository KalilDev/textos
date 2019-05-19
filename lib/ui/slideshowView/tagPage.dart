import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class TagPages extends StatefulWidget {
  @override
  _TagPagesState createState() => _TagPagesState();
}

class _TagPagesState extends State<TagPages> {
  QueryProvider provider;
  Stream _tagStream;
  IndexController _tagIndexController;

  @override
  void initState() {
    _tagStream = Firestore.instance
        .collection('metadata')
        .orderBy('order')
        .snapshots()
        .map((list) => list.documents.map((doc) => doc.data));
    _tagIndexController = new IndexController();
    super.initState();
  }

  @override
  void deactivate() {
    provider.shouldJump = true;
    super.deactivate();
  }

  List<Map<String, dynamic>> _metadatas;

  jump(int page) async {
    // Dirty
    Future.delayed(Duration(milliseconds: 1)).then((_) =>
        _tagIndexController.move(page, animation: false));
  }

  @override
  Widget build(BuildContext context) {
    if (provider == null) provider = Provider.of<QueryProvider>(context);
    if (provider.shouldJump) {
      provider.shouldJump = false;
      provider.justJumped = true;
      jump(provider.currentTagPage);
    }
    return StreamBuilder(
      stream: _tagStream,
      initialData: [Constants.placeholderTagMetadata],
      builder: (context, snapshot) {
        _metadatas = snapshot.data.toList();
        if (_metadatas.length == 0)
          _metadatas = [Constants.placeholderTagMetadata];
        return TransformerPageView(
          controller: _tagIndexController,
            itemCount: _metadatas.length,
            scrollDirection: Axis.vertical,
          viewportFraction: 0.90,
          onPageChanged: (page) {
            final provider = Provider.of<QueryProvider>(context);
            if (provider.justJumped) {
              if (page == provider.currentTagPage) provider.justJumped = false;
            } else {
              provider.currentTagPage = page;
              provider.updateStream(
                  {'collection': _metadatas[page]['collection']});
              HapticFeedback.lightImpact();
            }
          },
          transformer: new PageTransformerBuilder(builder: (widget, info) {
            final data = _metadatas[info.index];
              return _TagPage(
                info: info,
                tags: data['tags'],
                title: data['title'],
                authorName: data['authorName'],
              );
          }),
        );
      },
    );
  }
}

class _TagPage extends StatefulWidget {
  final TransformInfo info;
  final List tags;
  final String title;
  final String authorName;

  _TagPage({@required this.info,
    this.tags = const [],
    this.title = 'Textos do ',
    this.authorName = 'Kalil'});

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<_TagPage> {
  List<Widget> _buildButtons() {
    List<Widget> widgets = [];
    widgets.add(_CustomButton(
        isCurrent:
        widget.info.index == Provider
            .of<QueryProvider>(context)
            .currentTagPage,
        tag: Constants.textAllTag));
    widget.tags.forEach((tag) =>
        widgets.add(_CustomButton(
            isCurrent:
            widget.info.index == Provider
                .of<QueryProvider>(context)
                .currentTagPage,
            tag: tag)));
    return widgets;
  }

  BoxDecoration elevation(double position) {
    final shadowColor = Color.lerp(Theme
        .of(context)
        .backgroundColor, Theme
        .of(context)
        .canvasColor, position);
    final offset = 10 * position;
    if (Theme
        .of(context)
        .brightness == Brightness.dark) {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: shadowColor);
    } else {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme
              .of(context)
              .backgroundColor,
          boxShadow: [
            BoxShadow(
                color: Theme
                    .of(context)
                    .canvasColor,
                blurRadius: offset * 1.2,
                offset: Offset(offset, offset))
          ]);
    }
  }

  @override
  Widget build(context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: elevation(widget.info.position.abs()),
            margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title + widget.authorName,
                    style: Theme
                        .of(context)
                        .textTheme
                        .display1,
                  ),
                  Text(Constants.textFilter),
                  Container(
                    margin: EdgeInsets.only(left: 1.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildButtons()),
                  )
                ],
              ),
            ),
          ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({Key key, @required this.tag, @required this.isCurrent})
      : super(key: key);

  final String tag;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final queryTag = tag == Constants.textAllTag ? null : tag;
    return AnimatedSwitcher(
        duration: Constants.durationAnimationMedium,
        switchOutCurve: Curves.easeInOut,
        switchInCurve: Curves.easeInOut,
        transitionBuilder: (widget, animation) {
          return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
              child: widget);
        },
        child: isCurrent &&
            tag == Provider
                .of<QueryProvider>(context)
                .currentTag
            ? FlatButton(
            color: Theme
                .of(context)
                .accentColor,
            child: Text(
              '#' + tag,
            ),
            onPressed: () {
              HapticFeedback.selectionClick();
              Provider.of<QueryProvider>(context)
                  .updateStream({'tag': queryTag});
            })
            : OutlineButton(
            borderSide: BorderSide(color: Theme
                .of(context)
                .accentColor),
            child: Text(
              '#' + tag,
              style: Theme
                  .of(context)
                  .textTheme
                  .button
                  .copyWith(
                  color: Color.alphaBlend(
                      Theme
                          .of(context)
                          .accentColor
                          .withAlpha(120),
                      Theme
                          .of(context)
                          .textTheme
                          .button
                          .color)),
            ),
            onPressed: () {
              HapticFeedback.selectionClick();
              Provider.of<QueryProvider>(context)
                  .updateStream({'tag': queryTag});
            }));
  }
}
