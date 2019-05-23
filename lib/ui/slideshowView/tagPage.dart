import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class TagPages extends StatefulWidget {
  @override
  _TagPagesState createState() => _TagPagesState();
}

class _TagPagesState extends State<TagPages>
    with AutomaticKeepAliveClientMixin {
  Stream _tagStream;
  IndexController _tagIndexController;

  @override
  bool get wantKeepAlive => true;

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
  List<Map<String, dynamic>> _metadatas;

  jump(int page) async {
    // Dirty
    Future.delayed(Duration(milliseconds: 1))
        .then((_) => _tagIndexController.move(page, animation: false));
  }

  @override
  Widget build(BuildContext context) {
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
          curve: Curves.decelerate,
          physics: BouncingScrollPhysics(),
          onPageChanged: (page) {
            final provider = Provider.of<QueryProvider>(context);
            provider.currentTagPage = page;
            provider
                .updateStream({'collection': _metadatas[page]['collection']});
            HapticFeedback.lightImpact();
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
      isCurrent: widget.info.index ==
          Provider
              .of<QueryProvider>(context)
              .currentTagPage,
      tag: Constants.textAllTag,
      index: 0.0,
      position: widget.info.position,
    ));
    widget.tags.forEach((tag) =>
        widgets.add(_CustomButton(
          isCurrent: widget.info.index ==
              Provider
                  .of<QueryProvider>(context)
                  .currentTagPage,
          tag: tag,
          index: widget.tags.indexOf(tag) + 1.0,
          position: widget.info.position,
        )));
    return widgets;
  }

  @override
  Widget build(context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          ElevatedContainer(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            elevation: 16 * widget.info.position.abs(),
            margin: EdgeInsets.only(right: 20, top: 10, bottom: 10, left: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ParallaxContainer(
                      axis: Axis.vertical,
                      position: -widget.info.position,
                      translationFactor: 100,
                      child: Text(
                        widget.title + widget.authorName,
                        style: Theme
                            .of(context)
                            .accentTextTheme
                            .display1,
                      ),
                    ),
                    ParallaxContainer(
                        axis: Axis.vertical,
                        position: -widget.info.position,
                        translationFactor: 150,
                        child: Text(Constants.textFilter,
                            style: Theme
                                .of(context)
                                .accentTextTheme
                                .body1
                                .copyWith(
                              color: Color.alphaBlend(
                                  Theme
                                      .of(context)
                                      .accentTextTheme
                                      .body1
                                      .color
                                      .withAlpha(175),
                                  Theme
                                      .of(context)
                                      .backgroundColor),
                            ))),
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
          ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({Key key,
    @required this.tag,
    @required this.isCurrent,
    @required this.position,
    @required this.index})
      : super(key: key);

  final String tag;
  final bool isCurrent;
  final double position;
  final double index;

  @override
  Widget build(BuildContext context) {
    final queryTag = tag == Constants.textAllTag ? null : tag;
    return ParallaxContainer(
      axis: Axis.vertical,
      position: -position,
      translationFactor: 150 + 50 * (index + 1),
      opacityFactor: -position.abs() * 1.2 + 1,
      child: AnimatedSwitcher(
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
                  .primaryColor,
              child: Text(
                '#' + tag,
                style: Theme
                    .of(context)
                    .accentTextTheme
                    .button
                    .copyWith(
                    color: Theme
                        .of(context)
                        .primaryColorBrightness !=
                        Brightness.dark
                        ? Theme
                        .of(context)
                        .backgroundColor
                        : Theme
                        .of(context)
                        .accentTextTheme
                        .display1
                        .color),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                Provider.of<QueryProvider>(context)
                    .updateStream({'tag': queryTag});
              })
              : OutlineButton(
              borderSide: BorderSide(color: Theme
                  .of(context)
                  .primaryColor),
              child: Text(
                '#' + tag,
                style: Theme
                    .of(context)
                    .accentTextTheme
                    .button
                    .copyWith(
                    color: Color.alphaBlend(
                        Theme
                            .of(context)
                            .primaryColor
                            .withAlpha(120),
                        Theme
                            .of(context)
                            .accentTextTheme
                            .button
                            .color)
                        .withAlpha(175)),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                Provider.of<QueryProvider>(context)
                    .updateStream({'tag': queryTag});
              })),
    );
  }
}
