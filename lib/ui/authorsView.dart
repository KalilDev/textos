import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class AuthorsView extends StatefulWidget {
  const AuthorsView({@required this.isVisible});
  final bool isVisible;

  @override
  _AuthorsViewState createState() => _AuthorsViewState();
}

class _AuthorsViewState extends State<AuthorsView>
    with AutomaticKeepAliveClientMixin {
  Stream<Iterable<Map<String, dynamic>>> _tagStream;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tagStream = Firestore.instance
        .collection('metadata')
        .orderBy('order')
        .snapshots()
        .map<Iterable<Map<String, dynamic>>>((QuerySnapshot list) => list
            .documents
            .map<Map<String, dynamic>>((DocumentSnapshot snap) => snap.data));
    super.initState();
  }

  List<Map<String, dynamic>> _metadataList;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: StreamBuilder<Iterable<Map<String, dynamic>>>(
        stream: _tagStream,
        builder: (BuildContext context,
            AsyncSnapshot<Iterable<Map<String, dynamic>>> snapshot) {
          _metadataList = snapshot.hasData
              ? _metadataList = snapshot.data.toList()
              : _metadataList = <Map<String, dynamic>>[placeholderTagMetadata];
          return Provider<TextPageProvider>(
            builder: (_) => TextPageProvider(),
            child: Consumer<TextPageProvider>(
              builder: (BuildContext context, TextPageProvider provider, _) => TransformerPageView(
                itemCount: _metadataList.length,
                scrollDirection: Axis.vertical,
                viewportFraction: 0.90,
                curve: Curves.decelerate,
                onPageChanged: (int page) {
                  provider.currentPage = page;
                  Provider.of<QueryInfoProvider>(context).collection = _metadataList[page]['collection'];
                  SystemSound.play(SystemSoundType.click);
                  HapticFeedback.lightImpact();
                },
                transformer:
                    PageTransformerBuilder(builder: (_, TransformInfo info) {
                  if (widget.isVisible || provider.currentPage == info.index) {
                    final Map<String, dynamic> data = _metadataList[info.index];
                    return _AuthorPage(
                      info: info,
                      tags: data['tags'],
                      title: data['title'],
                      authorName: data['authorName'],
                    );
                  } else {
                    return const Placeholder();
                  }
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AuthorPage extends StatefulWidget {
  const _AuthorPage(
      {@required this.info,
      this.tags = const <String>[],
      this.title = 'Textos do ',
      this.authorName = 'Kalil'});

  final TransformInfo info;
  final List<dynamic> tags;
  final String title;
  final String authorName;

  @override
  _AuthorPageState createState() => _AuthorPageState();
}

class _AuthorPageState extends State<_AuthorPage> {
  List<Widget> _buildButtons() {
    final List<Widget> widgets = <Widget>[];
    widgets.add(_CustomButton(
      isCurrent: widget.info.position.round() == 0.0,
      tag: textAllTag,
      index: 0.0,
      position: widget.info.position,
    ));

    for (dynamic tag in widget.tags) {
      widgets.add(_CustomButton(
        isCurrent: widget.info.position.round() == 0.0,
        tag: tag,
        index: widget.tags.indexOf(tag) + 1.0,
        position: widget.info.position,
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          ElevatedContainer(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            elevation: 16 * widget.info.position.abs(),
            margin: const EdgeInsets.only(
                right: 20, top: 10, bottom: 10, left: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                margin: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ParallaxContainer(
                      axis: Axis.vertical,
                      position: -widget.info.position,
                      translationFactor: 100,
                      child: Text(
                        widget.title + widget.authorName,
                        style: Theme.of(context).accentTextTheme.display1,
                      ),
                    ),
                    ParallaxContainer(
                        axis: Axis.vertical,
                        position: -widget.info.position,
                        translationFactor: 150,
                        child: Text(textFilter,
                            style: Theme.of(context)
                                .accentTextTheme
                                .body1
                                .copyWith(
                                  color: getTextColor(0.60,
                                      bg: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      main: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ))),
                    Container(
                      margin: const EdgeInsets.only(left: 1.0),
                      child: RepaintBoundary(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildButtons()),
                      ),
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
  const _CustomButton(
      {Key key,
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
    final String queryTag = tag == textAllTag ? null : tag;
    return ParallaxContainer(
      axis: Axis.vertical,
      position: -position,
      translationFactor: 150 + 50 * (index + 1),
      opacityFactor: -position.abs() * 1.2 + 1,
      child: AnimatedSwitcher(
          duration: durationAnimationMedium,
          switchOutCurve: Curves.easeInOut,
          switchInCurve: Curves.easeInOut,
          transitionBuilder: (Widget widget, Animation<double> animation) {
            return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: widget);
          },
          child: isCurrent && tag == Provider.of<QueryInfoProvider>(context).tag
              ? FlatButton(
                  color: Theme.of(context).primaryColor,
                  highlightColor: Theme.of(context).accentColor,
                  child: Text(
                    '#' + tag,
                    style: Theme.of(context).accentTextTheme.button.copyWith(
                        color: Theme.of(context).primaryColorBrightness !=
                                Brightness.dark
                            ? Theme.of(context).backgroundColor
                            : Theme.of(context).accentTextTheme.display1.color),
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Provider.of<QueryInfoProvider>(context).tag = queryTag;
                  })
              : OutlineButton(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  highlightColor: Theme.of(context).accentColor,
                  child: Text(
                    '#' + tag,
                    style: Theme.of(context).accentTextTheme.button.copyWith(
                        color: Color.alphaBlend(
                                Theme.of(context).primaryColor.withAlpha(120),
                                Theme.of(context).accentTextTheme.button.color)
                            .withAlpha(175)),
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Provider.of<QueryInfoProvider>(context).tag = queryTag;
                  })),
    );
  }
}
