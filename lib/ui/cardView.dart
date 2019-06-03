import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/src/textUtils.dart';

class CardView extends StatelessWidget {
  const CardView({
    Key key,
    @required this.textContent,
  }) : super(key: key);

  final Content textContent;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        body: CardContent(textContent: textContent),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({@required this.textContent});

  final Content textContent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
            tag: 'image' + textContent.textPath,
            child: ImageBackground(
                img: textContent.imgUrl,
                enabled: false,
                key: Key('image' + textContent.textPath))),
        _TextWidget(textContent: textContent, textSize: Provider.of<TextSizeProvider>(context).textSize),
        Align(
          alignment: Alignment.bottomCenter,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  AbsorbPointer(
                    child: Container(
                      width: constraints.maxWidth,
                      height: 100.0,
                    ),
                  )),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  textContent.hasText
                      ? Container(
                          margin: const EdgeInsets.only(left: 4.0),
                          child: IncDecButton(
                              isBlurred: Provider.of<BlurProvider>(context)
                                  .buttonsBlur,
                              onDecrease: () =>
                                  Provider.of<TextSizeProvider>(context)
                                      .decrease(),
                              onIncrease: () =>
                                  Provider.of<TextSizeProvider>(context)
                                      .increase(),
                              value: Provider.of<TextSizeProvider>(context)
                                  .textSize))
                      : const SizedBox(),
                  textContent.hasMusic
                      ? Expanded(
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: RepaintBoundary(
                                child: PlaybackButton(
                                  url: textContent.music,
                                  isBlurred: Provider.of<BlurProvider>(context)
                                      .buttonsBlur,
                                ),
                              )))
                      : Spacer(),
                  Container(
                    margin: const EdgeInsets.only(right: 4.0),
                    child: RepaintBoundary(
                      child: BiStateFAB(
                        onPressed: () => Provider.of<FavoritesProvider>(context)
                            .toggle(
                                textContent.title + ';' + textContent.textPath),
                        isBlurred:
                            Provider.of<BlurProvider>(context).buttonsBlur,
                        isEnabled: Provider.of<FavoritesProvider>(context)
                            .isFavorite(
                                textContent.title + ';' + textContent.textPath),
                        disabledColor: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Positioned(
          child: MenuButton(),
          top: MediaQuery.of(context).padding.top - 2.5,
          left: -2.5,
        ),
      ],
    );
  }
}

class _TextWidget extends ImplicitlyAnimatedWidget {
  const _TextWidget({@required this.textContent, @required this.textSize}) : super(duration: durationAnimationShort);

  final Content textContent;
  final double textSize;

  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends AnimatedWidgetBaseState<_TextWidget> {
  Tween<double> _textSize;

  @override
  void forEachTween(TweenVisitor<dynamic>visitor) {
    _textSize = visitor(_textSize, widget.textSize, (dynamic value) => Tween<double>(begin: value));
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
                                                fontSize: _textSize.evaluate(animation) *
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
