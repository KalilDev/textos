import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/Providers/Providers.dart';
import 'package:vibration/vibration.dart';

class TagPages extends StatefulWidget {
  @override
  _TagPagesState createState() => _TagPagesState();
}

class _TagPagesState extends State<TagPages> {
  PageController _tagPageController;
  Stream _tagStream;

  @override
  void initState() {
    _tagPageController = new PageController(viewportFraction: 0.90);
    _tagStream = Firestore.instance.collection('metadata').orderBy('order')
        .snapshots()
        .map((list) => list.documents.map((doc) => doc.data));
    _addControllerListener();
    super.initState();
  }

  @override
  void deactivate() {
    _tagPageController.dispose();
    Provider
        .of<QueryProvider>(context)
        .disposed = true;
    super.deactivate();
  }

  _addControllerListener() {
    _tagPageController.addListener(() {
      final next = _tagPageController.page.round();
      if (Provider
          .of<QueryProvider>(context)
          .currentTagPage != next) {
        Provider
            .of<QueryProvider>(context)
            .currentTagPage = next;
        Provider.of<QueryProvider>(context).updateStream(
            {'collection': _metadatas[Provider
                .of<QueryProvider>(context)
                .currentTagPage]['collection']});
        Vibration.vibrate(duration: 60);
      }
    });
  }

  List<Map<String, dynamic>> _metadatas;

  @override
  Widget build(BuildContext context) {
    if (Provider
        .of<QueryProvider>(context)
        .disposed) {
      _tagPageController =
      new PageController(viewportFraction: 0.90, initialPage: Provider
          .of<QueryProvider>(context)
          .currentTagPage + 1);
      _addControllerListener();
      Provider
          .of<QueryProvider>(context)
          .disposed = false;
    }
    return StreamBuilder(
      stream: _tagStream,
      initialData: [Constants.placeholderTagMetadata],
      builder: (context, snapshot) {
        _metadatas = snapshot.data.toList();
        return PageView.builder(
            controller: _tagPageController,
            itemCount: _metadatas.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data = _metadatas[index];
              return _TagPage(index: index,
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
    widgets.add(_CustomButton(isCurrent: widget.index == Provider
        .of<QueryProvider>(context)
        .currentTagPage, tag: Constants.textAllTag));
    widget.tags.forEach((tag) =>
        widgets.add(_CustomButton(isCurrent: widget.index == Provider
            .of<QueryProvider>(context)
            .currentTagPage, tag: tag)));
    return widgets;
  }

  @override
  Widget build(context) {
    return Container(
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
        ));
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({
    Key key,
    @required this.tag,
    @required this.isCurrent
  }) : super(key: key);

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
        child: isCurrent && tag == Provider
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
              Vibration.vibrate(duration: 90);
              Provider.of<QueryProvider>(context).updateStream(
                  {'tag': queryTag});
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
                  .copyWith(color: Constants.themeAccent.shade400),
            ),
            onPressed: () {
              Vibration.vibrate(duration: 90);
              Provider.of<QueryProvider>(context).updateStream(
                  {'tag': queryTag});
            }));
  }
}
