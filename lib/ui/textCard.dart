import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/constants.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:textos/src/model/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/src/textUtils.dart';
import 'package:transformer_page_view/parallax.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({@required this.content, @required this.heroTag})
      : position = null,
        isSliver = false,
        callBack = null,
        trailing = null;
  const ContentCard.withParallax(
      {@required this.content, @required this.position, @required this.heroTag})
      : isSliver = false,
        callBack = null,
        trailing = null;
  const ContentCard.sliver(
      {@required this.content,
      @required this.callBack,
      @required this.heroTag,
      this.trailing})
      : position = null,
        isSliver = true;
  final Content content;
  final double position;
  final bool isSliver;
  final VoidCallback callBack;
  final Object heroTag;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    Widget getText() {
      if (content.title.length > 30 && isSliver) {
        return Container(
            child: Marquee(
                text: content.title,
                style: Theme.of(context).accentTextTheme.display1,
                blankSpace: 25,
                pauseAfterRound: const Duration(seconds: 1),
                velocity: 60.0),
            height: Theme.of(context).accentTextTheme.display1.fontSize);
      } else {
        return Text(
          content.title,
          style: Theme.of(context).accentTextTheme.display1,
          textAlign: TextAlign.center,
        );
      }
    }

    Widget extraTextBuilder(BuildContext context, BoxConstraints constraints) {
      final TextStyle text = Theme.of(context).textTheme.body1;
      final TextStyle date = Theme.of(context).textTheme.title;
      final double heightForText = constraints.maxHeight - date.fontSize - 15.0;
      final int lineCount = (heightForText / text.fontSize).floor();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Spacer(),
          if (lineCount > 0)
            RichText(
                maxLines: lineCount,
                textAlign: TextAlign.center,
                text: TextSpan(
                    children: formattedText(content.text, style: text))),
          Spacer(),
          if (heightForText > 0) Text(content.date, style: date),
          if (heightForText > 0)
            const SizedBox(
              height: 2.0,
            )
        ],
      );
    }

    return Stack(
      children: <Widget>[
        Hero(
            tag: 'image' + heroTag.toString(),
            child: position != null
                ? Container(
                    height: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: ParallaxImage.cachedNetwork(
                          content.imgUrl,
                          position: position,
                        )))
                : ImageBackground(
                    img: content.imgUrl,
                    enabled: false,
                    key: Key('image' + heroTag.toString()))),
        position != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Material(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.all(8.0),
                        child: Hero(
                            tag: 'body' + heroTag.toString(),
                            child: BlurOverlay.roundedRect(
                                radius: 15,
                                enabled: Provider.of<BlurProvider>(context)
                                    .textsBlur,
                                child: ParallaxContainer(
                                    translationFactor: 75,
                                    position: position,
                                    child: getText()))),
                      ),
                      color: Colors.transparent,
                    )),
              )
            : isSliver
                ? Hero(
                    tag: 'body' + heroTag.toString(),
                    child: BlurOverlay.roundedRect(
                      radius: 20.0,
                      color: Theme.of(context).backgroundColor.withAlpha(120),
                      enabled: Provider.of<BlurProvider>(context).textsBlur,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        child: InkWell(
                          child: Container(
                              child: Center(
                                  child: Row(
                            children: <Widget>[
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: durationAnimationMedium,
                                  transitionBuilder: (Widget child, Animation<double> animation) => SizeTransition(axisAlignment: 1.0,sizeFactor: animation, child: child),
                                  child: (content.date != null && content.text != null) ? Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: getText(),
                                      ),
                                      Expanded(
                                          child: Center(
                                            child: LayoutBuilder(
                                                builder: extraTextBuilder),
                                          )),
                                    ],
                                  )
                                  : Center(child: getText()),
                                ),
                              ),
                              if (trailing != null) trailing
                            ],
                          ))),
                          onTap: callBack,
                        ),
                      ),
                    ))
                : _TextWidget(
                    heroTag: heroTag,
                    textContent: content,
                    textSize: Provider.of<TextStyleProvider>(context).textSize),
      ],
    );
  }
}

class _TextWidget extends ImplicitlyAnimatedWidget {
  const _TextWidget(
      {@required this.textContent,
      @required this.textSize,
      @required this.heroTag})
      : super(duration: durationAnimationShort);

  final Content textContent;
  final double textSize;
  final Object heroTag;

  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends AnimatedWidgetBaseState<_TextWidget> {
  Tween<double> _textSize;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _textSize = visitor(_textSize, widget.textSize,
        (dynamic value) => Tween<double>(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
        onTap: () {
          SystemSound.play(SystemSoundType.click);
          HapticFeedback.heavyImpact();
          Navigator.of(context).pop();
        },
        child: SafeArea(
            child: Container(
                padding: const EdgeInsets.all(4),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Hero(
                  tag: 'body' + widget.heroTag.toString(),
                  child: BlurOverlay.roundedRect(
                    enabled: Provider.of<BlurProvider>(context).textsBlur,
                    radius: 20,
                    child: Column(
                      children: widget.textContent.hasText
                          ? <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: SingleChildScrollView(
                                    child: Column(children: <Widget>[
                                      Text(widget.textContent.title,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .accentTextTheme
                                              .display1),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: RichText(
                                            textAlign:
                                                Provider.of<TextStyleProvider>(
                                                        context)
                                                    .textAlign,
                                            text: TextSpan(
                                                children: formattedText(
                                                    widget.textContent.text,
                                                    style: textTheme.body1.copyWith(
                                                        fontSize:
                                                            _textSize.evaluate(
                                                                    animation) *
                                                                4.5)))),
                                      ),
                                      SizedBox(
                                          height: 56,
                                          child: Center(
                                              child: Text(
                                                  widget.textContent.date,
                                                  style: textTheme.title))),
                                      widget.textContent.hasMusic
                                          ? const SizedBox(height: 56)
                                          : const SizedBox(),
                                    ]),
                                  ),
                                ),
                              ),
                            ]
                          : <Widget>[
                              Text(widget.textContent.title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .accentTextTheme
                                      .display1),
                              Spacer(),
                              Center(
                                  child: Text(widget.textContent.date,
                                      style: textTheme.title)),
                              const SizedBox(height: 56),
                            ],
                    ),
                  ),
                ))));
  }
}
