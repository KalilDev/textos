import 'package:flutter/material.dart';
import 'package:textos/Src/Constants.dart';
import 'package:vibration/vibration.dart';

class TagPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool enableDarkMode;
  final double textSize;

  TagPage(
      {@required this.data,
      @required this.enableDarkMode,
      @required this.textSize});

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  @override
  void initState() {
    super.initState();
  }

  List get tags => widget.data['tags'];

  String get activeTag => tags[0];

  set activeTag(String tag) => tag;

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
                  //_queryDb(tag: tag);
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
                  //_queryDb(tag: tag);
                }));
  }

  List<Widget> _buildButtons() {
    List<Widget> widgets = [];
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
          widget.data['title'] + widget.data['authorName'],
          style: Constants().textstyleTitle(widget.textSize),
        ),
        Text(Constants.textFilter,
            style: Constants()
                .textstyleFilter(widget.textSize, widget.enableDarkMode)),
        Column(children: _buildButtons())
      ],
    ));
  }
}
