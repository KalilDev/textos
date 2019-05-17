import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';

class TagPages extends StatefulWidget {
  final PageController tagPageController;

  TagPages({@required this.tagPageController});

  @override
  _TagPagesState createState() => _TagPagesState();
}

class _TagPagesState extends State<TagPages> {
  QueryProvider provider;
  Stream _tagStream;

  @override
  void initState() {
    _tagStream = Firestore.instance
        .collection('metadata')
        .orderBy('order')
        .snapshots()
        .map((list) => list.documents.map((doc) => doc.data));
    super.initState();
  }

  @override
  void deactivate() {
    provider.shouldJump = true;
    super.deactivate();
  }

  _addControllerListener() {
    widget.tagPageController.addListener(() {
      final next = widget.tagPageController.page.round();
      if (provider.justJumped) {
        if (next == provider.currentTagPage) {
          provider.justJumped = false;
        }
      } else if (provider.currentTagPage != next) {
        provider.currentTagPage = next;
        provider.updateStream(
            {'collection': _metadatas[provider.currentTagPage]['collection']});
        HapticFeedback.lightImpact();
      }
    });
  }

  List<Map<String, dynamic>> _metadatas;

  @override
  Widget build(BuildContext context) {
    if (provider == null) provider = Provider.of<QueryProvider>(context);

    if (!widget.tagPageController.hasListeners) _addControllerListener();
    return StreamBuilder(
      stream: _tagStream,
      initialData: [Constants.placeholderTagMetadata],
      builder: (context, snapshot) {
        _metadatas = snapshot.data.toList();
        if (_metadatas.length == 0)
          _metadatas = [Constants.placeholderTagMetadata];
        return PageView.builder(
            controller: widget.tagPageController,
            itemCount: _metadatas.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data = _metadatas[index];
              return _TagPage(
                  index: index,
                  tags: data['tags'],
                  title: data['title'],
                  authorName: data['authorName']);
            });
      },
    );
  }
}

class _TagPage extends StatefulWidget {
  final int index;
  final List tags;
  final String title;
  final String authorName;

  _TagPage({@required this.index,
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
        widget.index == Provider
            .of<QueryProvider>(context)
            .currentTagPage,
        tag: Constants.textAllTag));
    widget.tags.forEach((tag) =>
        widgets.add(_CustomButton(
            isCurrent:
            widget.index == Provider
                .of<QueryProvider>(context)
                .currentTagPage,
            tag: tag)));
    return widgets;
  }

  @override
  Widget build(context) {
    return AnimatedTheme(
        duration: Constants.durationAnimationMedium,
        data: Theme.of(context).copyWith(
            canvasColor: widget.index ==
                Provider
                    .of<QueryProvider>(context)
                    .currentTagPage
                ? Constants.themeBackgroundDark
                : Theme
                .of(context)
                .canvasColor),
        child: LayoutBuilder(
          builder: (context, constraints) =>
              Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme
                        .of(context)
                        .canvasColor, width: 2.0)),
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
        ));
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
                  .copyWith(color: Color.alphaBlend(Theme
                  .of(context)
                  .accentColor
                  .withAlpha(120), Theme
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
