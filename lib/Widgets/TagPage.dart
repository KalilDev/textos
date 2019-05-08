import 'package:flutter/material.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/Controllers/QueryController.dart';
import 'package:textos/Src/Controllers/TagPageController.dart';
import 'package:vibration/vibration.dart';

class TagPage extends StatefulWidget {
  final int index;
  final bool enableDarkMode;
  final double textSize;
  final TagPageController tagPageController;
  final QueryController queryController;

  TagPage({@required this.index,
      @required this.enableDarkMode,
    @required this.textSize,
    @required this.tagPageController,
    @required this.queryController});

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  String activeTag;

  Map get data => widget.tagPageController.metadatas[widget.index];

  @override
  void initState() {
    super.initState();
    setState(() => activeTag = Constants.textAllTag);
  }

  List get tags => data['tags'];

  Widget _buildButton(String tag) {
    return AnimatedSwitcher(
        duration: Constants.durationAnimationMedium,
        switchOutCurve: Curves.easeInOut,
        switchInCurve: Curves.easeInOut,
        transitionBuilder: (widget, animation) {
          return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
              child: widget);
        },
        child: tag == activeTag
            ? FlatButton(
            color: Theme.of(context).accentColor,
            child: Text(
              '#' + tag,
              style: Constants().textStyleButton(widget.textSize),
            ),
            onPressed: () {
              Vibration.vibrate(duration: 90);
              setState(() {
                activeTag = tag;
              });
              widget.queryController.queryParameters = MapEntry('tag', tag);
            })
            : OutlineButton(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            child: Text(
              '#' + tag,
              style: Constants()
                  .textStyleButton(widget.textSize)
                  .copyWith(color: Constants.themeAccent.shade400),
            ),
            onPressed: () {
              Vibration.vibrate(duration: 90);
              setState(() {
                activeTag = tag;
              });
              widget.queryController.queryParameters = MapEntry('tag', tag);
            }));
  }

  List<Widget> _buildButtons() {
    List<Widget> widgets = [];
    widgets.add(_buildButton(Constants.textAllTag));
    tags.forEach((tag) => widgets.add(_buildButton(tag)));
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
              data['title'] + data['authorName'],
              style: Constants().textstyleTitle(widget.textSize),
            ),
            Text(Constants.textFilter,
                style: Constants()
                    .textstyleFilter(widget.textSize, widget.enableDarkMode)),
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
