import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/constants.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/src/model/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/src/textUtils.dart';
import 'package:transformer_page_view/parallax.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({@required this.content}) : position = null;
  const ContentCard.withParallax(
      {@required this.content, @required this.position});
  final Content content;
  final double position;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
            tag: 'image' + content.textPath,
            child: position != null
                ? ParallaxImage.cachedNetwork(content.imgUrl,
                    position: position)
                : ImageBackground(
                    img: content.imgUrl,
                    enabled: false,
                    key: Key('image' + content.textPath))),
        position != null
            ? BlurOverlay(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: ParallaxContainer(
                        translationFactor: 75,
                        position: position,
                        child: Text(content.title))),
                enabled: Provider.of<BlurProvider>(context).textsBlur)
            : _TextWidget(
                textContent: content,
                textSize: Provider.of<TextSizeProvider>(context).textSize),
      ],
    );
  }
}

class _TextWidget extends ImplicitlyAnimatedWidget {
  const _TextWidget({@required this.textContent, @required this.textSize})
      : super(duration: durationAnimationShort);

  final Content textContent;
  final double textSize;

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
            child: Hero(
          tag: 'body' + widget.textContent.textPath,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                                RichText(
                                    textAlign: TextAlign.justify,
                                    text: TextSpan(
                                        children: formattedText(
                                            widget.textContent.text,
                                            style: textTheme.body1.copyWith(
                                                fontSize: _textSize
                                                        .evaluate(animation) *
                                                    4.5)))),
                                SizedBox(
                                    height: 56,
                                    child: Center(
                                        child: Text(widget.textContent.date,
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
                            style: Theme.of(context).accentTextTheme.display1),
                        Spacer(),
                        Center(
                            child: Text(widget.textContent.date,
                                style: textTheme.title)),
                        const SizedBox(height: 56),
                      ],
              ),
            ),
          ),
        )));
  }
}
